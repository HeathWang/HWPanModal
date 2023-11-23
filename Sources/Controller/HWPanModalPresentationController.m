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
#import "HWPanModalInteractiveAnimator.h"
#import "HWPanModalPresentationDelegate.h"
#import "UIViewController+PanModalPresenter.h"
#import "HWPanIndicatorView.h"
#import "UIView+HW_Frame.h"
#import "HWPanModalPresentableHandler.h"

@interface HWPanModalPresentationController () <UIGestureRecognizerDelegate, HWPanModalPresentableHandlerDelegate, HWPanModalPresentableHandlerDataSource>

// 判断弹出的view是否在做动画
@property (nonatomic, assign) BOOL isPresentedViewAnimating;
@property (nonatomic, assign) PresentationState currentPresentationState;

@property (nonatomic, strong) id<HWPanModalPresentable> presentable;

// view
@property (nonatomic, strong) HWDimmedView *backgroundView;
@property (nonatomic, strong) HWPanContainerView *panContainerView;
@property (nonatomic, strong) UIView<HWPanModalIndicatorProtocol> *dragIndicatorView;

@property (nonatomic, strong) HWPanModalPresentableHandler *handler;

@end

@implementation HWPanModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController {
	self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
	if (self) {
		_handler = [[HWPanModalPresentableHandler alloc] initWithPresentable:[self presentable]];
		_handler.delegate = self;
		_handler.dataSource = self;
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

#pragma mark - Tracking the Transition Start and End

- (void)presentationTransitionWillBegin {
    [[self presentable] panModalTransitionWillBegin];

	if (!self.containerView)
		return;
    
    [self layoutBackgroundView:self.containerView];

    if ([[self presentable] originPresentationState] == PresentationStateLong) {
    	self.currentPresentationState = PresentationStateLong;
    } else if ([[self presentable] originPresentationState] == PresentationStateMedium) {
        self.currentPresentationState = PresentationStateMedium;
    }

	[self layoutPresentedView:self.containerView];
	[self.handler configureScrollViewInsets];

	if (!self.presentedViewController.transitionCoordinator) {
		self.backgroundView.dimState = DimStateMax;
		return;
	}

	__weak  typeof(self) wkSelf = self;
	__block BOOL isAnimated = NO;
	[self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		wkSelf.backgroundView.dimState = DimStateMax;
		[wkSelf.presentedViewController setNeedsStatusBarAppearanceUpdate];
		isAnimated = YES;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		if (!isAnimated) {
			/// In some cases, for example, present a `hw` when a navigation controller is pushing a new vc, `animateAlongsideTransition` will not call.
			/// If not called, call it here.
			wkSelf.backgroundView.dimState = DimStateMax;
			[wkSelf.presentedViewController setNeedsStatusBarAppearanceUpdate];
		}
        if ([[wkSelf presentable] allowsTouchEventsPassingThroughTransitionView]) {
            // hack TransitionView
            [wkSelf.containerView setValue:@(YES) forKey:@"ignoreDirectTouchEvents"];
        }
    }];

}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [[self presentable] panModalTransitionDidFinish];
	if (completed)
		return;

	[self.backgroundView removeFromSuperview];
    [self.presentedView endEditing:YES];
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

- (void)dismissalTransitionDidEnd:(BOOL)completed {
	if (completed) {
		// break the delegate
		self.delegate = nil;
	}
}

#pragma mark - UIContentContainer protocol

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	[coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		if (self && [self presentable]) {
			[self adjustPresentedViewFrame];

			if ([self.presentable shouldRoundTopCorners]) {
				[self addRoundedCornersToView:self.panContainerView.contentView];
			}
            [self updateDragIndicatorView];
		}
	} completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		[self transitionToState:self.currentPresentationState animated:NO];
	}];
}

#pragma mark - public method

- (void)setNeedsLayoutUpdate {
	[self configureViewLayout];
	[self adjustPresentedViewFrame];

    [self updateBackgroundColor];
	[self updateContainerViewShadow];
	[self updateDragIndicatorView];
	[self updateRoundedCorners];

	[self.handler observeScrollable];
	[self.handler configureScrollViewInsets];
    [self checkEdgeInteractive];
}

- (void)transitionToState:(PresentationState)state animated:(BOOL)animated {

    if (![self.presentable shouldTransitionToState:state])
        return;

    [self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
    [self.presentable willTransitionToState:state];

    switch (state) {
        case PresentationStateLong: {
            [self snapToYPos:self.handler.longFormYPosition animated:animated];
        }
            break;
        case PresentationStateMedium: {
            [self snapToYPos:self.handler.mediumFormYPosition animated:animated];
        }
            break;
        case PresentationStateShort: {
            [self snapToYPos:self.handler.shortFormYPosition animated:animated];
        }
            break;
    }
    self.currentPresentationState = state;
    [[self presentable] didChangeTransitionToState:state];
}

- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated {
	[self.handler setScrollableContentOffset:offset animated:animated];
}

- (void)updateUserHitBehavior {
    [self checkVCContainerEventPass];
    [self checkBackgroundViewEventPass];
}

#pragma mark - layout

- (void)adjustPresentedViewFrame {

	if (!self.containerView)
		return;

	CGRect frame = self.containerView.frame;
	CGSize size = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) - self.handler.anchoredYPosition);

	self.presentedView.hw_size = frame.size;
	self.panContainerView.contentView.frame = CGRectMake(0, 0, size.width, size.height);
	self.presentedViewController.view.frame = self.panContainerView.contentView.bounds;
    [self.presentedViewController.view setNeedsLayout];
    [self.presentedViewController.view layoutIfNeeded];
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
	self.backgroundView.blurTintColor = [self.presentable backgroundConfig].blurTintColor;
}

- (void)layoutPresentedView:(UIView *)containerView {
	if (!self.presentable)
		return;
    
    self.handler.presentedView = self.presentedView;
    
	[containerView addSubview:self.presentedView];
	[containerView addGestureRecognizer:self.handler.panGestureRecognizer];

	if ([self.presentable allowScreenEdgeInteractive]) {
		[containerView addGestureRecognizer:self.handler.screenEdgeGestureRecognizer];
        [self.handler.screenEdgeGestureRecognizer addTarget:self action:@selector(screenEdgeInteractiveAction:)];
	}

	[self setNeedsLayoutUpdate];
	[self adjustPanContainerBackgroundColor];
    
    [[self presentable] presentedViewDidMoveToSuperView];
}

- (void)adjustPanContainerBackgroundColor {
	self.panContainerView.contentView.backgroundColor = self.presentedViewController.view.backgroundColor ? : [self.presentable panScrollable].backgroundColor;
}

- (void)updateDragIndicatorView {
	if ([self.presentable showDragIndicator]) {
		[self addDragIndicatorViewToView:self.panContainerView];
	} else {
        self.dragIndicatorView.hidden = YES;
	}
}

- (void)addDragIndicatorViewToView:(UIView *)view {
	// if has been add, won't update it.
    self.dragIndicatorView.hidden = NO;
    
    CGSize indicatorSize = [self.dragIndicatorView indicatorSize];
    
    if (self.dragIndicatorView.superview == view) {
        self.dragIndicatorView.frame = CGRectMake((view.hw_width - indicatorSize.width) / 2, -kIndicatorYOffset - indicatorSize.height, indicatorSize.width, indicatorSize.height);
        [self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
        return;
    }

    self.handler.dragIndicatorView = self.dragIndicatorView;
	[view addSubview:self.dragIndicatorView];
	
    self.dragIndicatorView.frame = CGRectMake((view.hw_width - indicatorSize.width) / 2, -kIndicatorYOffset - indicatorSize.height, indicatorSize.width, indicatorSize.height);
	[self.dragIndicatorView setupSubviews];
	[self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
}

- (void)updateRoundedCorners {
	if ([self.presentable shouldRoundTopCorners]) {
		[self addRoundedCornersToView:self.panContainerView.contentView];
	} else {
		[self resetRoundedCornersToView:self.panContainerView.contentView];
	}
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

- (void)resetRoundedCornersToView:(UIView *)view {
	view.layer.mask = nil;
	view.layer.shouldRasterize = NO;
}

- (void)updateContainerViewShadow {
    HWPanModalShadow *shadow = [[self presentable] contentShadow];
    if (shadow.shadowColor) {
        [self.panContainerView updateShadow:shadow.shadowColor shadowRadius:shadow.shadowRadius shadowOffset:shadow.shadowOffset shadowOpacity:shadow.shadowOpacity];
    } else {
		[self.panContainerView clearShadow];
	}
}


/**
 * Calculates & stores the layout anchor points & options
 */
- (void)configureViewLayout {
    
    [self.handler configureViewLayout];
    self.containerView.userInteractionEnabled = [[self presentable] isUserInteractionEnabled];
}

#pragma mark - event passing through

- (void)checkVCContainerEventPass {
    BOOL eventPassValue = [[self presentable] allowsTouchEventsPassingThroughTransitionView];
    // hack TransitionView
    [self.containerView setValue:@(eventPassValue) forKey:@"ignoreDirectTouchEvents"];
}

- (void)checkBackgroundViewEventPass {
    if ([[self presentable] allowsTouchEventsPassingThroughTransitionView]) {
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.tapBlock = nil;
    } else {
        self.backgroundView.userInteractionEnabled = YES;
        __weak typeof(self) wkSelf = self;
        self.backgroundView.tapBlock = ^(UITapGestureRecognizer *recognizer) {
            if ([[wkSelf presentable] allowsTapBackgroundToDismiss]) {
                [wkSelf dismiss:NO mode:PanModalInteractiveModeNone];
            }
        };
    }
}

#pragma mark - y position update

- (void)snapToYPos:(CGFloat)yPos animated:(BOOL)animated {

	if (animated) {
		[HWPanModalAnimator animate:^{
			self.isPresentedViewAnimating = YES;
			[self adjustToYPos:yPos];
		} config:self.presentable completion:^(BOOL completion) {
			self.isPresentedViewAnimating = NO;
		}];
	} else {
		[self adjustToYPos:yPos];
	}
}

- (void)adjustToYPos:(CGFloat)yPos {
	self.presentedView.hw_top = MAX(yPos, self.handler.anchoredYPosition);

	// change dim background starting from shortFormYPosition.
	if (self.presentedView.frame.origin.y >= self.handler.shortFormYPosition) {

		CGFloat yDistanceFromShortForm = self.presentedView.frame.origin.y - self.handler.shortFormYPosition;
		CGFloat bottomHeight = self.containerView.hw_height - self.handler.shortFormYPosition;
		CGFloat percent = yDistanceFromShortForm / bottomHeight;
		self.backgroundView.dimState = DimStatePercent;
		self.backgroundView.percent = 1 - percent;

		[self.presentable panModalGestureRecognizer:self.handler.panGestureRecognizer dismissPercent:MIN(percent, 1)];
		if (self.presentedViewController.isBeingDismissed) {
			[[self interactiveAnimator] updateInteractiveTransition:MIN(percent, 1)];
		}
	} else {
		self.backgroundView.dimState = DimStateMax;
	}
}

#pragma mark - HWPanModalPresentableHandlerDelegate

- (void)adjustPresentableYPos:(CGFloat)yPos {
	[self adjustToYPos:yPos];
}

- (void)dismiss:(BOOL)isInteractive mode:(PanModalInteractiveMode)mode {
    [self dismiss:isInteractive mode:mode animated:YES completion:nil];
}

- (void)dismiss:(BOOL)isInteractive mode:(PanModalInteractiveMode)mode animated:(BOOL)animated completion:(void (^)(void))completion {
    self.presentedViewController.hw_panModalPresentationDelegate.interactive = isInteractive;
    self.presentedViewController.hw_panModalPresentationDelegate.interactiveMode = mode;
    [self.presentable panModalWillDismiss];
    [self.presentedViewController dismissViewControllerAnimated:animated completion:^{
        if (completion) completion();
        [self.presentable panModalDidDismissed];
    }];
}

- (void)dismissAnimated:(BOOL)animated completion:(nonnull void (^)(void))completion {
    [self dismiss:NO mode:PanModalInteractiveModeNone animated:animated completion:completion];
}

- (void)presentableTransitionToState:(PresentationState)state {
	[self transitionToState:state animated:YES];
}

- (PresentationState)getCurrentPresentationState {
    return self.currentPresentationState;
}

#pragma mark - interactive handle

- (void)finishInteractiveTransition {
	if (self.presentedViewController.isBeingDismissed) {
        // make the containerView can not response event action.
        self.containerView.userInteractionEnabled = NO;
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

#pragma mark - HWPanModalPresentableHandlerDataSource

- (CGSize)containerSize {
	return  self.containerView.bounds.size;
}

- (BOOL)isBeingDismissed {
	return self.presentedViewController.isBeingDismissed;
}

- (BOOL)isBeingPresented {
    return self.presentedViewController.isBeingPresented;
}

- (BOOL)isPresentedViewAnchored {
    
    if (![[self presentable] shouldRespondToPanModalGestureRecognizer:self.handler.panGestureRecognizer]) {
        return YES;
    }
    
    if (!self.isPresentedViewAnimating && self.handler.extendsPanScrolling && (CGRectGetMinY(self.presentedView.frame) <= self.handler.anchoredYPosition || HW_TWO_FLOAT_IS_EQUAL(CGRectGetMinY(self.presentedView.frame), self.handler.anchoredYPosition))) {
        return YES;
    }
    return NO;
}

- (BOOL)isPresentedControllerInteractive {
    return self.presentedViewController.hw_panModalPresentationDelegate.interactive;
}

- (BOOL)isFormPositionAnimating {
    return self.isPresentedViewAnimating;
}

#pragma mark - Screen Gesture enevt

- (void)screenEdgeInteractiveAction:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat percent = translation.x / CGRectGetWidth(recognizer.view.bounds);
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
			[self dismiss:YES mode:PanModalInteractiveModeSideslip];
		}
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (percent > 0.5 || velocity.x >= [[self presentable] minHorizontalVelocityToTriggerScreenEdgeDismiss]) {
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
    //TODO: changed the user interactive, if someone else has different requirements, change it.
    self.handler.screenEdgeGestureRecognizer.enabled = [[self presentable] allowScreenEdgeInteractive];
}

#pragma mark - Getter

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
			_backgroundView = [[HWDimmedView alloc] initWithBackgroundConfig:[self.presentable backgroundConfig]];
		} else {
			_backgroundView = [[HWDimmedView alloc] init];
		}
        
        if ([[self presentable] allowsTouchEventsPassingThroughTransitionView]) {
            _backgroundView.userInteractionEnabled = NO;
        } else {
            __weak typeof(self) wkSelf = self;
            _backgroundView.tapBlock = ^(UITapGestureRecognizer *recognizer) {
                if ([[wkSelf presentable] allowsTapBackgroundToDismiss]) {
                    [wkSelf dismiss:NO mode:PanModalInteractiveModeNone];
                }
            };
        }

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

@end
