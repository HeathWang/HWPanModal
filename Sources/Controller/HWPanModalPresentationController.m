//
//  HWPanModalPresentationController.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWPanModalPresentationController.h"
#import "HWDimmedView.h"
#import "HWPanContainerView.h"
#import "UIViewController+LayoutHelper.h"
#import "HWPanModalAnimator.h"
#import <KVOController/KVOController.h>
#import "HWPanModalInteractiveAnimator.h"
#import "HWPanModalPresentationDelegate.h"
#import "UIViewController+PanModalPresenter.h"
#import "HWPanIndicatorView.h"
#import "UIView+HW_Frame.h"

static CGFloat const kIndicatorYOffset = 5;
static CGFloat const kSnapMovementSensitivity = 0.7;
static NSString *const kScrollViewKVOContentOffsetKey = @"contentOffset";

@interface UIScrollView (Helper)

@property (nonatomic, assign, readonly) BOOL isScrolling;

@end

@interface HWPanModalPresentationController () <UIGestureRecognizerDelegate>

// 判断弹出的view是否在做动画
@property (nonatomic, assign) BOOL isPresentedViewAnimating;

// HWPanModalPresentable config
@property (nonatomic, assign) BOOL extendsPanScrolling;

@property (nonatomic, assign) BOOL anchorModalToLongForm;

@property (nonatomic, assign) CGFloat scrollViewYOffset;

@property (nonatomic, assign) CGFloat shortFormYPosition;

@property (nonatomic, assign) CGFloat longFormYPosition;

@property (nonatomic, assign) CGFloat anchoredYPosition;

@property (nonatomic, assign) PresentationState currentPresentationState;

@property (nonatomic, strong) id<HWPanModalPresentable> presentable;

// view
@property (nonatomic, strong) HWDimmedView *backgroundView;
@property (nonatomic, strong) HWPanContainerView *panContainerView;
@property (nonatomic, strong) UIView<HWPanModalIndicatorProtocol> *dragIndicatorView;

// gesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenGestureRecognizer;

// keyboard handle
@property (nonatomic, copy) NSDictionary *keyboardInfo;

@end

@implementation HWPanModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController {
	self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
	if (self) {
		// make props as default
		_extendsPanScrolling = YES;
		_anchorModalToLongForm = YES;
        [self addKeyboardObserver];
	}

	return self;
}

#pragma mark - overridden

- (UIView *)presentedView {
	return self.panContainerView;
}

- (void)containerViewWillLayoutSubviews {
	[super containerViewWillLayoutSubviews];
	[self configureViewLayout];
}

- (void)presentationTransitionWillBegin {

	if (!self.containerView)
		return;

	[self layoutBackgroundView:self.containerView];
	[self layoutPresentedView:self.containerView];
	[self configureScrollViewInsets];

	if (!self.presentedViewController.transitionCoordinator) {
		self.backgroundView.dimState = DimStateMax;
		return;
	}

	__weak  typeof(self) wkSelf = self;
	[self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		wkSelf.backgroundView.dimState = DimStateMax;
		[self.presentedViewController setNeedsStatusBarAppearanceUpdate];
	} completion:nil];

}

- (void)presentationTransitionDidEnd:(BOOL)completed {
	if (completed)
		return;

	[self.backgroundView removeFromSuperview];
    [self.panContainerView endEditing:YES];
}

- (void)dismissalTransitionWillBegin {
	id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentedViewController.transitionCoordinator;
	if (!transitionCoordinator) {
		self.backgroundView.dimState = DimStateOff;
		return;
	}

	__weak  typeof(self) wkSelf = self;
	[transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		wkSelf.dragIndicatorView.alpha = 0;
		wkSelf.backgroundView.dimState = DimStateOff;
		[wkSelf.presentedViewController setNeedsStatusBarAppearanceUpdate];
	} completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {

	}];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	[coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		if (self && [self presentable]) {
			[self adjustPresentedViewFrame];

			if ([self.presentable shouldRoundTopCorners]) {
				[self addRoundedCornersToView:self.panContainerView.contentView];
			}
		}
	} completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		[self transitionToState:self.currentPresentationState];
	}];
}

#pragma mark - public method

- (void)setNeedsLayoutUpdate {
	[self configureViewLayout];
    [self updateBackgroundColor];
	[self adjustPresentedViewFrame];
	[self checkEdgeInteractive];
	[self observe:[self.presentable panScrollable]];
	[self configureScrollViewInsets];
}

- (void)transitionToState:(PresentationState)state {
	[self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
	if (![self.presentable shouldTransitionToState:state])
		return;

	[self.presentable willTransitionToState:state];

	switch (state) {
		case PresentationStateLong: {
			[self snapToYPos:self.longFormYPosition];
		}
			break;
		case PresentationStateShort:{
			[self snapToYPos:self.shortFormYPosition];
		}
			break;
		default:
			break;
	}
	self.currentPresentationState = state;
}

- (void)setContentOffset:(CGPoint)offset {
	if (![self.presentable panScrollable])
		return;

	UIScrollView *scrollView = [self.presentable panScrollable];
	[self.KVOController unobserve:scrollView];

	[scrollView setContentOffset:offset animated:YES];
    // wait for animation finished.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self trackScrolling:scrollView];
        
        [self observe:scrollView];
    });
	
}

#pragma mark - layout

- (BOOL)isPresentedViewAnchored {
    if (!self.isPresentedViewAnimating && self.extendsPanScrolling && CGRectGetMinY(self.presentedView.frame) <= self.anchoredYPosition) {
        return YES;
    }
    return NO;
}

- (void)adjustPresentedViewFrame {

	if (!self.containerView)
		return;

	CGRect frame = self.containerView.frame;
	CGSize size = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) - self.anchoredYPosition);

	self.presentedView.hw_size = frame.size;
	self.panContainerView.contentView.frame = CGRectMake(0, 0, size.width, size.height);
	self.presentedViewController.view.frame = self.panContainerView.contentView.bounds;
    [self.presentedViewController.view setNeedsLayout];
    [self.presentedViewController.view layoutIfNeeded];
}

- (void)configureScrollViewInsets {

	// when scrolling, return
	if ([self.presentable panScrollable] && ![self.presentable panScrollable].isScrolling) {
		UIScrollView *scrollView = [self.presentable panScrollable];
		// 禁用scrollView indicator除非用户开始滑动scrollView
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollEnabled = [self.presentable isPanScrollEnabled];
		scrollView.scrollIndicatorInsets = [self.presentable scrollIndicatorInsets];

		UIEdgeInsets insets1 = scrollView.contentInset;
        /*
         * If scrollView has been set contentInset, and bottom is NOT zero, we won't change it.
         * If contentInset.bottom is zero, set bottom = bottomLayoutOffset
         * If scrollView has been set contentInset, BUT the bottom < bottomLayoutOffset, set bottom = bottomLayoutOffset
         */
        if (HW_FLOAT_IS_ZERO(insets1.bottom) || insets1.bottom < self.presentedViewController.bottomLayoutOffset) {
            
            insets1.bottom = self.presentedViewController.bottomLayoutOffset;
            scrollView.contentInset = insets1;
        }
		
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
	}
}

/**
 * add backGroundView并设置约束
 */
- (void)layoutBackgroundView:(UIView *)containerView {
	[containerView addSubview:self.backgroundView];
    [self updateBackgroundColor];
	self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

    NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:@{@"backgroundView": self.backgroundView}];
    NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:@{@"backgroundView": self.backgroundView}];
    [NSLayoutConstraint activateConstraints:hCons];
    [NSLayoutConstraint activateConstraints:vCons];
}

- (void)updateBackgroundColor {
    self.backgroundView.blurTintColor = [self.presentable backgroundBlurColor];
}

- (void)layoutPresentedView:(UIView *)containerView {
	if (!self.presentable)
		return;

	[containerView addSubview:self.presentedView];
	[containerView addGestureRecognizer:self.panGestureRecognizer];

	if ([self.presentable allowScreenEdgeInteractive]) {
		[containerView addGestureRecognizer:self.screenGestureRecognizer];
	}

	if ([self.presentable shouldRoundTopCorners]) {
		[self addRoundedCornersToView:self.panContainerView.contentView];
	}

	if ([self.presentable showDragIndicator]) {
		[self addDragIndicatorViewToView:self.panContainerView];
	}

	[self setNeedsLayoutUpdate];
	[self adjustPanContainerBackgroundColor];
}

- (void)adjustPanContainerBackgroundColor {
	self.panContainerView.contentView.backgroundColor = self.presentedViewController.view.backgroundColor ? : [self.presentable panScrollable].backgroundColor;
}

- (void)addDragIndicatorViewToView:(UIView *)view {
	[view addSubview:self.dragIndicatorView];
	CGSize indicatorSize = [self.dragIndicatorView indicatorSize];
	self.dragIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
	// layout
    NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.presentedView attribute:NSLayoutAttributeTop multiplier:1 constant:-kIndicatorYOffset];
    NSLayoutConstraint *centerXCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.presentedView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:indicatorSize.width];
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:indicatorSize.height];

    [view addConstraints:@[bottomCons, centerXCons, widthCons, heightCons]];

	[self.dragIndicatorView setupSubviews];
	[self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
}

- (void)addRoundedCornersToView:(UIView *)view {
	CGFloat radius = [self.presentable cornerRadius];

	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
	
	CAShapeLayer *mask = [CAShapeLayer new];
	mask.path = bezierPath.CGPath;
	view.layer.mask = mask;

	// 提高性能
	view.layer.shouldRasterize = YES;
	view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)snapToYPos:(CGFloat)yPos {
	[HWPanModalAnimator animate:^{
        self.isPresentedViewAnimating = YES;
		[self adjustToYPos:yPos];
	} config:self.presentable completion:^(BOOL completion) {
		self.isPresentedViewAnimating = NO;
	}];
}

- (void)adjustToYPos:(CGFloat)yPos {
    self.presentedView.hw_top = MAX(yPos, self.anchoredYPosition);
    
    // change dim background starting from shortFormYPosition.
	if (self.presentedView.frame.origin.y >= self.shortFormYPosition) {
        
        CGFloat yDistanceFromShortForm = self.presentedView.frame.origin.y - self.shortFormYPosition;
        CGFloat bottomHeight = self.containerView.hw_height - self.shortFormYPosition;
        CGFloat percent = yDistanceFromShortForm / bottomHeight;
		self.backgroundView.dimState = DimStatePercent;
		self.backgroundView.percent = 1 - percent;

		[self.presentable panModalGestureRecognizer:self.panGestureRecognizer dismissPercent:MIN(percent, 1)];
		if (self.presentedViewController.isBeingDismissed) {
            [[self interactiveAnimator] updateInteractiveTransition:MIN(percent, 1)];
        }
	} else {
		self.backgroundView.dimState = DimStateMax;
	}
}

/**
 * Calculates & stores the layout anchor points & options
 */
- (void)configureViewLayout {
    
    if ([self.presentedViewController conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        UIViewController<HWPanModalPresentable> *layoutPresentable = (UIViewController <HWPanModalPresentable> *) self.presentedViewController;

        self.shortFormYPosition = layoutPresentable.shortFormYPos;
        self.longFormYPosition = layoutPresentable.longFormYPos;
        self.anchorModalToLongForm = [layoutPresentable anchorModalToLongForm];
        self.extendsPanScrolling = [layoutPresentable allowsExtendedPanScrolling];

        self.containerView.userInteractionEnabled = [layoutPresentable isUserInteractionEnabled];
    }
}

#pragma mark - UIScrollView handle

- (void)observe:(UIScrollView *)scrollView {
    
    if (!scrollView) {
        return;
    }
    
    self.scrollViewYOffset = MAX(scrollView.contentOffset.y, -(MAX(scrollView.contentInset.top, 0)));

	__weak typeof(self) wkSelf = self;
	[self.KVOController observe:scrollView keyPath:kScrollViewKVOContentOffsetKey options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary<NSString *, id > *change) {
		if (wkSelf.containerView != nil) {
			[wkSelf didPanOnScrollView:object change:change];
		}
	}];
}

/**
 As the user scrolls, track & save the scroll view y offset.
 This helps halt scrolling when we want to hold the scroll view in place.
*/
- (void)trackScrolling:(UIScrollView *)scrollView {
    self.scrollViewYOffset = MAX(scrollView.contentOffset.y, -(MAX(scrollView.contentInset.top, 0)));
    scrollView.showsVerticalScrollIndicator = [[self presentable] showsScrollableHorizontalScrollIndicator];
}

/**
 * Halts the scroll of a given scroll view & anchors it at the `scrollViewYOffset`
 */
- (void)haltScrolling:(UIScrollView *)scrollView {
	[scrollView setContentOffset:CGPointMake(0, self.scrollViewYOffset) animated:NO];
	scrollView.showsVerticalScrollIndicator = NO;

}

- (void)didPanOnScrollView:(UIScrollView *)scrollView change:(NSDictionary<NSKeyValueChangeKey, id> *)change {

	if (!self.presentedViewController.isBeingDismissed && !self.presentedViewController.isBeingPresented) {

		if (!self.isPresentedViewAnchored && scrollView.contentOffset.y > 0) {
			[self haltScrolling:scrollView];
		} else if ([scrollView isScrolling] || self.isPresentedViewAnimating) {

			/**
			 While we're scrolling upwards on the scrollView,
			 store the last content offset position
            */
			if (self.isPresentedViewAnchored) {
				[self trackScrolling:scrollView];
			} else {
				/**
				 * Keep scroll view in place while we're panning on main view
				 */
				[self haltScrolling:scrollView];
			}
		}
//        else if ([self.presentedViewController.view isKindOfClass:UIScrollView.class] && !self.isPresentedViewAnimating && scrollView.contentOffset.y <= 0) {
//            /**
//             * In the case where we drag down quickly on the scroll view and let go,
//             `handleScrollViewTopBounce` adds a nice elegant touch.
//             */
//            [self handleScrollViewTopBounce:scrollView change:change];
//        }
        else {
			[self trackScrolling:scrollView];
		}

    } else {
		/**
		 * 当present Controller，而且动画没有结束的时候，用户可能会对scrollView设置contentOffset
		 * 首次用户滑动scrollView时，会因为scrollViewYOffset = 0而出现错位
		 */
		[self setContentOffset:scrollView.contentOffset];
	}
}

/**
 To ensure that the scroll transition between the scrollView & the modal
 is completely seamless, we need to handle the case where content offset is negative.

 In this case, we follow the curve of the decelerating scroll view.
 This gives the effect that the modal view and the scroll view are one view entirely.

 - Note: This works best where the view behind view controller is a UIScrollView.
 So, for example, a UITableViewController.
*/
- (void)handleScrollViewTopBounce:(UIScrollView *)scrollView change:(NSDictionary<NSKeyValueChangeKey, id> *)change {
	NSValue *value = change[NSKeyValueChangeOldKey];
	if (value) {
		CGPoint offset = [value CGPointValue];
		CGFloat yOffset = scrollView.contentOffset.y;
        
		CGSize presentedSize = self.containerView.frame.size;
		self.presentedView.hw_size = CGSizeMake(presentedSize.width, presentedSize.height + yOffset);
		self.panContainerView.contentView.hw_size = CGSizeMake(self.presentedView.hw_width, self.presentedView.hw_height - self.anchoredYPosition);
        self.presentedViewController.view.frame = self.panContainerView.contentView.bounds;

		if (offset.y > yOffset) {
			self.presentedView.hw_top = self.longFormYPosition - yOffset;
		} else {
			self.scrollViewYOffset = 0;
			[self snapToYPos:self.longFormYPosition];
		}

		scrollView.showsVerticalScrollIndicator = NO;
	}
}

#pragma mark - Pan Gesture Event Handler

- (void)didPanOnView:(UIPanGestureRecognizer *)panGestureRecognizer {


	if ([self shouldResponseToPanGestureRecognizer:panGestureRecognizer] && self.containerView && !self.keyboardInfo) {

		CGPoint velocity = [panGestureRecognizer velocityInView:self.presentedView];

		switch (panGestureRecognizer.state) {

			case UIGestureRecognizerStateBegan:
			case UIGestureRecognizerStateChanged: {
				[self respondToPanGestureRecognizer:panGestureRecognizer];

				if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
				    // check if toggle dismiss action
				    if ([[self presentable] presentingVCAnimationStyle] > PresentingViewControllerAnimationStyleNone &&
                        velocity.y > 0 &&
                        (self.presentedView.frame.origin.y > self.shortFormYPosition || HW_TWO_FLOAT_IS_EQUAL(self.presentedView.frame.origin.y, self.shortFormYPosition))) {
                        [self dismissPresentedViewControllerIsInteractive:YES mode:PanModalInteractiveModeDragDown];
                    }
				}

				if (HW_TWO_FLOAT_IS_EQUAL(self.presentedView.frame.origin.y, self.anchoredYPosition) && self.extendsPanScrolling) {
					[self.presentable willTransitionToState:PresentationStateLong];
				}

				// update drag indicator
				if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
					if (velocity.y > 0) {
						[self.dragIndicatorView didChangeToState:HWIndicatorStatePullDown];
					} else if (velocity.y < 0 && self.presentedView.frame.origin.y <= self.anchoredYPosition && !self.extendsPanScrolling) {
						[self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
					}
				}

			}
				break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed: {

				/**
				 * pan recognizer结束
				 * 根据velocity(速度)，当velocity.y < 0，说明用户在向上拖拽view；当velocity.y > 0，向下拖拽
				 * 根据拖拽的速度，处理不同的情况：
				 * 1.超过拖拽速度阈值时并且向下拖拽，dismiss controller
				 * 2.向上拖拽永远不会dismiss，回弹至相应的状态
				 */

				if ([self isVelocityWithinSensitivityRange:velocity.y]) {
					if (velocity.y < 0) {
						[self transitionToState:PresentationStateLong];
                        [self cancelInteractiveTransition];
                    } else if ((HW_TWO_FLOAT_IS_EQUAL([self nearestDistance:CGRectGetMinY(self.presentedView.frame) inDistances:@[@(self.longFormYPosition), @(self.containerView.frame.size.height)]], self.longFormYPosition) && CGRectGetMinY(self.presentedView.frame) < self.shortFormYPosition) ||
							![self.presentable allowsDragToDismiss]) {
						[self transitionToState:PresentationStateShort];
                        [self cancelInteractiveTransition];
                    } else {
                        if (self.presentedViewController.isBeingDismissed) {
                            [self finishInteractiveTransition];
                        } else {
                            [self dismissPresentedViewControllerIsInteractive:NO mode:PanModalInteractiveModeNone];
                        }
                    }
				} else {
					CGFloat position = [self nearestDistance:CGRectGetMinY(self.presentedView.frame) inDistances:@[@(self.containerView.frame.size.height), @(self.shortFormYPosition), @(self.longFormYPosition)]];

					if (HW_TWO_FLOAT_IS_EQUAL(position, self.longFormYPosition)) {
						[self transitionToState:PresentationStateLong];
                        [self cancelInteractiveTransition];
                    } else if (HW_TWO_FLOAT_IS_EQUAL(position, self.shortFormYPosition) || ![self.presentable allowsDragToDismiss]) {
						[self transitionToState:PresentationStateShort];
                        [self cancelInteractiveTransition];
                    } else {
                        
                        if (self.presentedViewController.isBeingDismissed) {
                            [self finishInteractiveTransition];
                        } else {
                            [self dismissPresentedViewControllerIsInteractive:NO mode:PanModalInteractiveModeNone];
                        }
                    }
				}

			}
				break;
            default: break;
		}
	} else {
		switch (panGestureRecognizer.state) {
			case UIGestureRecognizerStateEnded:
			case UIGestureRecognizerStateCancelled:
			case UIGestureRecognizerStateFailed: {
				[self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
                [self cancelInteractiveTransition];
            }
				break;
			default:
				break;
		}
		[panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
	}

}

- (BOOL)shouldResponseToPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	if ([self.presentable shouldRespondToPanModalGestureRecognizer:panGestureRecognizer] ||
			!(panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateCancelled)) {

		return ![self shouldFailPanGestureRecognizer:panGestureRecognizer];
	} else {
	    // stop pan gesture working.
        panGestureRecognizer.enabled = NO;
		panGestureRecognizer.enabled = YES;
		return NO;
	}
}

- (BOOL)shouldFailPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    if ([self shouldPrioritizePanGestureRecognizer:panGestureRecognizer]) {
        // high priority than scroll view gesture, disable scrollView gesture.
        [self.presentable panScrollable].panGestureRecognizer.enabled = NO;
        [self.presentable panScrollable].panGestureRecognizer.enabled = YES;
        return NO;
    }

    BOOL shouldFail = NO;
    UIScrollView *scrollView = [self.presentable panScrollable];
    if (scrollView) {
        shouldFail = scrollView.contentOffset.y > -MAX(scrollView.contentInset.top, 0);

        // we want scroll the panScrollable, not the presentedView
        if (self.isPresentedViewAnchored && shouldFail) {
            CGPoint location = [panGestureRecognizer locationInView:self.presentedView];
            BOOL flag = CGRectContainsPoint(scrollView.frame, location) || scrollView.isScrolling;
            if (flag) {
				[self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
            }
            return flag;
        } else {
            return NO;
        }

    } else {
        return NO;
    }
    
}

- (BOOL)shouldPrioritizePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
	return recognizer.state == UIGestureRecognizerStateBegan && [[self presentable] shouldPrioritizePanModalGestureRecognizer:recognizer];
}

- (void)respondToPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	[self.presentable willRespondToPanModalGestureRecognizer:panGestureRecognizer];

	CGFloat yDisplacement = [panGestureRecognizer translationInView:self.presentedView].y;

	if (self.presentedView.frame.origin.y < self.longFormYPosition) {
		yDisplacement = yDisplacement / 2;
	}

	[self adjustToYPos:self.presentedView.frame.origin.y + yDisplacement];
    [panGestureRecognizer setTranslation:CGPointZero inView:self.presentedView];
}

- (BOOL)isVelocityWithinSensitivityRange:(CGFloat)velocity {
	return (ABS(velocity) - (1000 * (1 - kSnapMovementSensitivity))) > 0;
}

- (CGFloat)nearestDistance:(CGFloat)position inDistances:(NSArray *)distances {

	if (distances.count <= 0) {
		return position;
	}
    
	// TODO: need refine this sort code.
	NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:distances.count];
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:distances.count];

	[distances enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSNumber *number = obj;
		NSNumber *absValue = @(fabs(number.floatValue - position));
		[tmpArr addObject:absValue];
        [tmpDict setObject:number forKey:absValue];
		
	}];

	[tmpArr sortUsingSelector:@selector(compare:)];

	NSNumber *result = tmpDict[tmpArr.firstObject];
	return result.floatValue;
}

- (void)dismissPresentedViewControllerIsInteractive:(BOOL)isInteractive mode:(PanModalInteractiveMode)mode {
    self.presentedViewController.hw_panModalPresentationDelegate.interactive = isInteractive;
    self.presentedViewController.hw_panModalPresentationDelegate.interactiveMode = mode;
    [self.presentable panModalWillDismiss];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self.presentable panModalDidDismissed];
    }];
}

#pragma mark - Screen Gesture enevt

- (void)screenEdgeInteractiveAction:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat percent = translation.x / CGRectGetWidth(recognizer.view.bounds);

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self dismissPresentedViewControllerIsInteractive:YES mode:PanModalInteractiveModeSideslip];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }

        }
            break;
        case UIGestureRecognizerStateChanged: {

            [[self interactiveAnimator] updateInteractiveTransition:percent];
        }
            break;
        default:
            break;
    }
}

- (void)checkEdgeInteractive {
	if ([self.presentedViewController isKindOfClass:UINavigationController.class]) {
		UINavigationController *navigationController = (UINavigationController *) self.presentedViewController;
		if ((navigationController.topViewController != navigationController.viewControllers.firstObject) &&
			[[self presentable] allowScreenEdgeInteractive] &&
			navigationController.viewControllers.count > 0) {
			self.screenGestureRecognizer.enabled = NO;
		} else if ([[self presentable] allowScreenEdgeInteractive]) {
			self.screenGestureRecognizer.enabled = YES;
		}
	}
}


#pragma mark - interactive handle

- (void)finishInteractiveTransition {
    if (self.presentedViewController.isBeingDismissed) {
        [[self interactiveAnimator] finishInteractiveTransition];

        if (self.presentedViewController.hw_panModalPresentationDelegate.interactiveMode != PanModalInteractiveModeDragDown)
            return;

        if ([[self presentable] presentingVCAnimationStyle] > PresentingViewControllerAnimationStyleNone) {
            [HWPanModalAnimator animate:^{
                [self presentedView].hw_top = self.containerView.frame.size.height;
                self.dragIndicatorView.alpha = 0;
                self.backgroundView.dimState = DimStateOff;
            } config:[self presentable] completion:^(BOOL completion) {

            }];
        }
    }
}

- (void)cancelInteractiveTransition {
    if (self.presentedViewController.isBeingDismissed) {
        [[self interactiveAnimator] cancelInteractiveTransition];
        self.presentedViewController.hw_panModalPresentationDelegate.interactiveMode = PanModalInteractiveModeNone;
        self.presentedViewController.hw_panModalPresentationDelegate.interactive = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

/**
 * 只有当其他的UIGestureRecognizer为pan recognizer时才能同时存在
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
		return [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class];
	}
	return NO;
}

/**
 * 当当前手势为screenGestureRecognizer时，其他pan recognizer都应该fail
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	if (gestureRecognizer == self.screenGestureRecognizer && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
		return YES;
	}
	return NO;
}

#pragma mark - UIKeyboard Handle

- (void)addKeyboardObserver {
    if ([self.presentable isAutoHandleKeyboardEnabled]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    UIView<UIKeyInput> *currentInput = [self findCurrentTextInputInView:self.panContainerView];

    if (!currentInput)
		return;

    self.keyboardInfo = notification.userInfo;
	[self updatePanContainerFrameForKeyboard];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardInfo = nil;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve) [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];

    self.panContainerView.transform = CGAffineTransformIdentity;

    [UIView commitAnimations];
}

- (void)updatePanContainerFrameForKeyboard {
	if (!self.keyboardInfo)
		return;

	UIView<UIKeyInput> *textInput = [self findCurrentTextInputInView:self.panContainerView];
	if (!textInput)
		return;
    
    CGAffineTransform lastTransform = self.panContainerView.transform;
    self.panContainerView.transform = CGAffineTransformIdentity;
    
	CGFloat textViewBottomY = [textInput convertRect:textInput.bounds toView:self.panContainerView].origin.y + textInput.hw_height;
	CGFloat keyboardHeight = [self.keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

	CGFloat offsetY = 0;
	CGFloat top = [self.presentable keyboardOffsetFromInputView];
	offsetY = self.panContainerView.hw_height - (keyboardHeight + top + textViewBottomY + self.panContainerView.hw_top);

	NSTimeInterval duration = [self.keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve curve = (UIViewAnimationCurve) [self.keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

    self.panContainerView.transform = lastTransform;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:curve];
	[UIView setAnimationDuration:duration];

	self.panContainerView.transform = CGAffineTransformMakeTranslation(0, offsetY);

	[UIView commitAnimations];
}

- (UIView <UIKeyInput> *)findCurrentTextInputInView:(UIView *)view {
	if ([view conformsToProtocol:@protocol(UIKeyInput)] && view.isFirstResponder) {
		// Quick fix for web view issue
		if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")] || [view isKindOfClass:NSClassFromString(@"WKContentView")]) {
			return nil;
		}
		return (UIView <UIKeyInput> *) view;
	}

	for (UIView *subview in view.subviews) {
		UIView <UIKeyInput> *inputInView = [self findCurrentTextInputInView:subview];
		if (inputInView) {
			return inputInView;
		}
	}
	return nil;
}

#pragma mark - Getter

- (CGFloat)anchoredYPosition {
	CGFloat defaultTopOffset = [self.presentable topOffset];
	return self.anchorModalToLongForm ? self.longFormYPosition : defaultTopOffset;
}

- (id <HWPanModalPresentable>)presentable {
	if ([self.presentedViewController conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        return (id <HWPanModalPresentable>) self.presentedViewController;
	}
    return nil;
}

- (HWPanModalInteractiveAnimator *)interactiveAnimator {
	HWPanModalPresentationDelegate *presentationDelegate = self.presentedViewController.hw_panModalPresentationDelegate;
	return presentationDelegate.interactiveDismissalAnimator;
}

- (HWDimmedView *)backgroundView {
	if (!_backgroundView) {
		if (self.presentable) {
			_backgroundView = [[HWDimmedView alloc] initWithDimAlpha:[self.presentable backgroundAlpha] blurRadius:[self.presentable backgroundBlurRadius]];
		} else {
			_backgroundView = [[HWDimmedView alloc] init];
		}

		__weak typeof(self) wkSelf = self;
		_backgroundView.tapBlock = ^(UITapGestureRecognizer *recognizer) {
			if ([[wkSelf presentable] allowsTapBackgroundToDismiss]) {
                [wkSelf dismissPresentedViewControllerIsInteractive:NO mode:PanModalInteractiveModeNone];
			}
		};
	}
    
    return _backgroundView;
}

- (HWPanContainerView *)panContainerView {
	if (!_panContainerView) {
		_panContainerView = [[HWPanContainerView alloc] initWithPresentedView:self.presentedViewController.view frame:self.containerView.frame];
	}

	return _panContainerView;
}

- (UIView<HWPanModalIndicatorProtocol> *)dragIndicatorView {
    
	if (!_dragIndicatorView) {
        if ([self presentable] &&
			[[self presentable] respondsToSelector:@selector(customIndicatorView)] &&
			[[self presentable] customIndicatorView] != nil) {
            _dragIndicatorView = [[self presentable] customIndicatorView];
            // set the indicator size first in case `setupSubviews` can Not get the right size.
            _dragIndicatorView.hw_size = [[[self presentable] customIndicatorView] indicatorSize];
        } else {
            _dragIndicatorView = [HWPanIndicatorView new];
        }
	}
    
	return _dragIndicatorView;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
	if (!_panGestureRecognizer) {
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnView:)];
		_panGestureRecognizer.minimumNumberOfTouches = 1;
		_panGestureRecognizer.maximumNumberOfTouches = 1;
		_panGestureRecognizer.delegate = self;
	}
	return _panGestureRecognizer;
}

- (UIScreenEdgePanGestureRecognizer *)screenGestureRecognizer {
	if (!_screenGestureRecognizer) {
		_screenGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgeInteractiveAction:)];
		_screenGestureRecognizer.minimumNumberOfTouches = 1;
		_screenGestureRecognizer.maximumNumberOfTouches = 1;
		_screenGestureRecognizer.delegate = self;
		_screenGestureRecognizer.edges = UIRectEdgeLeft;
	}

	return _screenGestureRecognizer;
}

#pragma mark - dealloc

- (void)dealloc {
	[self removeKeyboardObserver];
}

@end

@implementation UIScrollView (Helper)

- (BOOL)isScrolling {
    return (self.isDragging && !self.isDecelerating) || self.isTracking;
}


@end
