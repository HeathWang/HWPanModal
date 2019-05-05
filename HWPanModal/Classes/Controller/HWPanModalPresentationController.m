//
//  HWPanModalPresentationController.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWPanModalPresentationController.h"
#import "HWPanModalPresentable.h"
#import "HWDimmedView.h"
#import "HWPanContainerView.h"
#import "UIViewController+LayoutHelper.h"
#import "HWPanModalAnimator.h"

#define kDragIndicatorSize  CGSizeMake(36, 5)
static CGFloat const kIndicatorYOffset = 5;
static CGFloat const kSnapMovementSensitivity = 0.7;

@interface UIScrollView (Helper)

@property (nonatomic, assign, readonly) BOOL isScrolling;

@end

@interface HWPanModalPresentationController () <UIGestureRecognizerDelegate>

// 判断弹出的view是否在做动画
@property (nonatomic, assign) BOOL isPresentedViewAnimating;

@property (nonatomic, assign) BOOL extendsPanScrolling;

@property (nonatomic, assign) BOOL anchorModalToLongForm;

@property (nonatomic, assign) CGFloat scrollViewYOffset;

@property (nonatomic, assign) CGFloat shortFormYPosition;

@property (nonatomic, assign) CGFloat longFormYPosition;

@property (nonatomic, assign) CGFloat anchoredYPosition;

@property (nonatomic, strong) id<HWPanModalPresentable> presentable;

@property (nonatomic, strong) HWDimmedView *backgroundView;
@property (nonatomic, strong) HWPanContainerView *panContainerView;
@property (nonatomic, strong) UIView *dragIndicatorView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation HWPanModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController {
	self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
	if (self) {
		// make props as default
		_extendsPanScrolling = YES;
		_anchorModalToLongForm = YES;
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

#pragma mark - public method

- (void)setNeedsLayoutUpdate {
	[self configureViewLayout];
	[self adjustPresentedViewFrame];
	[self observe:[self.presentable panScrollable]];
	[self configureScrollViewInsets];
}

- (void)transitionToState:(PresentationState)state {
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
}

- (void)setContentOffset:(CGPoint)offset {
	if (![self.presentable panScrollable])
		return;

	UIScrollView *scrollView = [self.presentable panScrollable];

	[scrollView removeObserver:self forKeyPath:@"contentOffset"];
	[scrollView setContentOffset:offset animated:YES];
	[self trackScrolling:scrollView];

	[self observe:scrollView];
}

#pragma mark - layout

- (BOOL)isPresentedViewAnchored {
    if (!self.isPresentedViewAnimating && self.extendsPanScrolling && CGRectGetMinY(self.presentedView.frame) <= self.anchoredYPosition) {
        return YES;
    }
    return NO;
}

- (void)adjustPresentedViewFrame {
	CGRect frame = self.containerView.frame;
	CGSize size = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) - self.anchoredYPosition);
	frame.size = size;
	self.presentedViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
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
		insets1.bottom = self.presentedViewController.bottomLayoutGuide.length;
		scrollView.contentInset = insets1;

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
	self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 9.0, *)) {
        [self.backgroundView.topAnchor constraintEqualToAnchor:containerView.topAnchor].active = YES;
        [self.backgroundView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor].active = YES;
        [self.backgroundView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor].active = YES;
        [self.backgroundView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor].active = YES;
    } else {

        NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:@{@"backgroundView": self.backgroundView}];
        NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:@{@"backgroundView": self.backgroundView}];
        [NSLayoutConstraint activateConstraints:hCons];
		[NSLayoutConstraint activateConstraints:vCons];
	}
}

- (void)layoutPresentedView:(UIView *)containerView {
	if (!self.presentable)
		return;

	[containerView addSubview:self.presentedView];
	[containerView addGestureRecognizer:self.panGestureRecognizer];

	if ([self.presentable showDragIndicator]) {
		[self addDragIndicatorViewToView:self.presentedView];
	}

	if ([self.presentable shouldRoundTopCorners]) {
		[self addRoundedCornersToView:self.presentedView];
	}

	[self setNeedsLayoutUpdate];
	[self adjustPanContainerBackgroundColor];
}

- (void)adjustPanContainerBackgroundColor {
	self.panContainerView.backgroundColor = self.presentedViewController.view.backgroundColor ? : [self.presentable panScrollable].backgroundColor;

}

- (void)addDragIndicatorViewToView:(UIView *)view {
	[view addSubview:self.dragIndicatorView];
	self.dragIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 9.0, *)) {
        [self.dragIndicatorView.bottomAnchor constraintEqualToAnchor:view.topAnchor constant:-kIndicatorYOffset].active = YES;
        [self.dragIndicatorView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor].active = YES;
        [self.dragIndicatorView.widthAnchor constraintEqualToConstant:kDragIndicatorSize.width].active = YES;
        [self.dragIndicatorView.heightAnchor constraintEqualToConstant:kDragIndicatorSize.height].active = YES;
    } else {

    	NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:-kIndicatorYOffset];
    	NSLayoutConstraint *centerXCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    	NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kDragIndicatorSize.width];
    	NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:self.dragIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kDragIndicatorSize.height];

		[view addConstraints:@[bottomCons, centerXCons, widthCons, heightCons]];
	}
	
}

- (void)addRoundedCornersToView:(UIView *)view {
	CGFloat radius = [self.presentable cornerRadius];

	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];

	if ([self.presentable showDragIndicator]) {
		CGFloat indicatorLeftEdgeXPos = view.bounds.size.width / 2 - kDragIndicatorSize.width / 2;
		[self drawAroundDragIndicator:bezierPath indicatorLeftEdgeXPos:indicatorLeftEdgeXPos];
	}

	CAShapeLayer *mask = [CAShapeLayer new];
	mask.path = bezierPath.CGPath;
	view.layer.mask = mask;

	// 提高性能
	view.layer.shouldRasterize = YES;
	view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)drawAroundDragIndicator:(UIBezierPath *)path indicatorLeftEdgeXPos:(CGFloat)edgeXPos {
	CGFloat totalIndicatorOffset = kIndicatorYOffset + kDragIndicatorSize.height;
	[path addLineToPoint:CGPointMake(edgeXPos, path.currentPoint.y)];
	[path addLineToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y - totalIndicatorOffset)];
	[path addLineToPoint:CGPointMake(path.currentPoint.x + kDragIndicatorSize.width, path.currentPoint.y)];
	[path addLineToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y + totalIndicatorOffset)];
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
	CGRect rect = self.presentedView.frame;
	rect.origin.y = MAX(yPos, self.anchoredYPosition);
	self.presentedView.frame = rect;

	if (self.presentedView.frame.origin.y > self.shortFormYPosition) {
		CGFloat yDisplacementFromShortForm = self.presentedView.frame.origin.y - self.shortFormYPosition;
		self.backgroundView.dimState = DimStatePercent;
		self.backgroundView.percent = 1 - yDisplacementFromShortForm / self.presentedView.frame.size.height;
	} else {
		self.backgroundView.dimState = DimStateMax;
	}
}

/**
 * Caluclates & stores the layout anchor points & options
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

#pragma mark - UIScrollView Observer

- (void)observe:(UIScrollView *)scrollView {
	if (!scrollView)
		return;

	[scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {

	// In case we have a situation where we have two containerViews in the same presentation
    if ([keyPath isEqualToString:@"contentOffset"] && [object isKindOfClass:UIScrollView.class] && self.containerView != nil) {
        [self didPanOnScrollView:object change:change];
    }
}

/**
 As the user scrolls, track & save the scroll view y offset.
 This helps halt scrolling when we want to hold the scroll view in place.
*/
- (void)trackScrolling:(UIScrollView *)scrollView {
	self.scrollViewYOffset = MAX(scrollView.contentOffset.y, 0);
	scrollView.showsVerticalScrollIndicator = YES;
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
		} else if ([self.presentedViewController.view isKindOfClass:UIScrollView.class] && !self.isPresentedViewAnimating && scrollView.contentOffset.y <= 0) {
			/**
			 * In the case where we drag down quickly on the scroll view and let go,
             `handleScrollViewTopBounce` adds a nice elegant touch.
			 */
			[self handleScrollViewTopBounce:scrollView change:change];
		} else {
			[self trackScrolling:scrollView];
		}

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
//		NSLog(@"offset:%@", NSStringFromCGPoint(offset));
		CGFloat yOffset = scrollView.contentOffset.y;
		CGSize presentedSize = self.containerView.frame.size;

		CGRect rect = self.presentedView.bounds;
		rect.size = CGSizeMake(presentedSize.width, presentedSize.height + yOffset);
		self.presentedView.bounds = rect;

		if (offset.y > yOffset) {
			CGRect rect1 = self.presentedView.frame;
			rect1.origin.y = self.longFormYPosition - yOffset;
			self.presentedView.frame = rect1;
		} else {
			self.scrollViewYOffset = 0;
			[self snapToYPos:self.longFormYPosition];
		}

		scrollView.showsVerticalScrollIndicator = NO;
	}
}

#pragma mark - Pan Gesture Event Handler

- (void)didPanOnView:(UIPanGestureRecognizer *)panGestureRecognizer {
	if ([self.presentable isPanScrollEnabled] && ![self shouldFailPanGestureRecognizer:panGestureRecognizer] && self.containerView) {

		switch (panGestureRecognizer.state) {

			case UIGestureRecognizerStateBegan:
			case UIGestureRecognizerStateChanged:
			{
				[self respondToPanGestureRecognizer:panGestureRecognizer];

				if (self.presentedView.frame.origin.y == self.anchoredYPosition && self.extendsPanScrolling) {
					[self.presentable willTransitionToState:PresentationStateLong];
				}
			}
                break;
			default:
			{

				/**
				 * pan recognizer结束
				 * 根据velocity(速度)，当velocity.y < 0，说明用户在向上拖拽view；当velocity.y > 0，向下拖拽
				 * 根据拖拽的速度，处理不同的情况：
				 * 1.超过拖拽速度阈值时并且向下拖拽，dismiss controller
				 * 2.向上拖拽永远不会dismiss，回弹至相应的状态
				 */
				CGPoint velocity = [panGestureRecognizer velocityInView:self.presentedView];
//                NSLog(@"velocity: %f", velocity.y);
				if ([self isVelocityWithinSensitivityRange:velocity.y]) {
					if (velocity.y < 0) {
						[self transitionToState:PresentationStateLong];
					} else if (([self nearestDistance:CGRectGetMinY(self.presentedView.frame) inDistances:@[@(self.longFormYPosition), @(self.containerView.frame.size.height)]] == self.longFormYPosition &&
							CGRectGetMinY(self.presentedView.frame) < self.shortFormYPosition) ||
							![self.presentable allowsDragToDismiss]) {
						[self transitionToState:PresentationStateShort];
					}
					else {
						[self dismissPresentedViewController];
					}
				} else {
					CGFloat  position = [self nearestDistance:CGRectGetMinY(self.presentedView.frame) inDistances:@[@(self.containerView.frame.size.height), @(self.shortFormYPosition), @(self.longFormYPosition)]];

					if (position == self.longFormYPosition) {
						[self transitionToState:PresentationStateLong];
					} else if (position == self.shortFormYPosition || ![self.presentable allowsDragToDismiss]) {
						[self transitionToState:PresentationStateShort];
					} else {
						[self dismissPresentedViewController];
					}
				}

			}
				break;
		}


	} else {
		[panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
	}
}


- (BOOL)shouldFailPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {

	if ([self.presentable shouldPrioritizePanRecognizer:panGestureRecognizer]) {
		[self.presentable panScrollable].panGestureRecognizer.enabled = YES;
		return NO;
	}

	if (self.isPresentedViewAnchored && [self.presentable panScrollable] && [self.presentable panScrollable].contentOffset.y > 0) {
        UIScrollView *scrollView = [self.presentable panScrollable];
		CGPoint location = [panGestureRecognizer locationInView:self.presentedView];
        return CGRectContainsPoint(scrollView.frame, location) || scrollView.isScrolling;
	} else {
		return NO;
	}
}

- (void)respondToPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	[self.presentable willRespondToPanRecognizer:panGestureRecognizer];

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
		NSNumber *absValue = @(ABS(number.floatValue - position));
		[tmpArr addObject:absValue];
		tmpDict[absValue.stringValue] = number;
	}];

	[tmpArr sortUsingSelector:@selector(compare:)];

	NSNumber *result = tmpDict[((NSNumber *)tmpArr.firstObject).stringValue];
//    NSLog(@"distances:%@\nresult:%@", distances, result);
	return result.floatValue;
}

- (void)dismissPresentedViewController {
	[self.presentable panModalWillDismiss];
	[self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate

/**
 * 只有当其他的UIGestureRecognizer为pan recognizer时才能同时存在
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class];
}

/**
 * 不需要其他GestureRecognizer去fail pan recognizer
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return NO;
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

- (HWDimmedView *)backgroundView {
	if (!_backgroundView) {
		if (self.presentable) {
			_backgroundView = [[HWDimmedView alloc] initWithDimAlpha:[self.presentable backgroundAlpha]];
		} else {
			_backgroundView = [[HWDimmedView alloc] init];
		}

		__weak typeof(self) wkSelf = self;
		_backgroundView.tapBlock = ^(UITapGestureRecognizer *recognizer){
			[wkSelf dismissPresentedViewController];
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

- (UIView *)dragIndicatorView {
	if (!_dragIndicatorView) {
		_dragIndicatorView = [UIView new];
		_dragIndicatorView.backgroundColor = [UIColor lightGrayColor];
		_dragIndicatorView.layer.cornerRadius = kDragIndicatorSize.height / 2;
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

- (void)dealloc {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self.presentable panScrollable]) {
        [[self.presentable panScrollable] removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
}

@end

@implementation UIScrollView (Helper)

- (BOOL)isScrolling {
    return (self.isDragging && !self.isDecelerating) || self.isTracking;
}


@end
