//
//  HWPanModalPresentationAnimator.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "HWPanModalPresentationAnimator.h"
#import "HWPanModalAnimator.h"
#import "UIViewController+LayoutHelper.h"
#import "HWPanContainerView.h"
#import "UIView+HW_Frame.h"
#import "HWPageSheetPresentingAnimation.h"
#import "HWShoppingCartPresentingAnimation.h"

@interface HWPresentingVCTransitionContext : NSObject <HWPresentingViewControllerContextTransitioning>

@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIView *containerView;

- (instancetype)initWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC duration:(NSTimeInterval)duration containerView:(UIView *)containerView;

@end

@interface HWPanModalPresentationAnimator ()

@property (nonatomic, assign) TransitionStyle transitionStyle;

@property (nullable, nonatomic, strong) UISelectionFeedbackGenerator *feedbackGenerator API_AVAILABLE(ios(10.0));
@property (nonatomic, strong) HWPresentingVCTransitionContext *presentingVCTransitionContext;
@property (nonatomic, assign) PanModalInteractiveMode interactiveMode;

@end

@implementation HWPanModalPresentationAnimator

- (instancetype)initWithTransitionStyle:(TransitionStyle)transitionStyle interactiveMode:(PanModalInteractiveMode)mode {
	self = [super init];
	if (self) {
		_transitionStyle = transitionStyle;
		_interactiveMode = mode;
		if (transitionStyle == TransitionStylePresentation) {
			if (@available(iOS 10.0, *)) {
				_feedbackGenerator = [UISelectionFeedbackGenerator new];
				[_feedbackGenerator prepare];
			} else {
				// Fallback on earlier versions
			}
		}
	}

	return self;
}

/**
 * 弹出controller动画
 */
- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)context {

	UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
	if (!toVC && !fromVC)
		return;
    
    UIViewController<HWPanModalPresentable> *presentable = [self panModalViewController:context];

    if ([presentable shouldEnableAppearanceTransition]) {
        // If you are implementing a custom container controller, use this method to tell the child that its views are about to appear or disappear.
        [fromVC beginAppearanceTransition:NO animated:YES];
        [self beginAppearanceTransitionForController:toVC isAppearing:YES animated:YES];
    }
    
    
	CGFloat yPos = presentable.shortFormYPos;
	if ([presentable originPresentationState] == PresentationStateLong) {
		yPos = presentable.longFormYPos;
    } else if ([presentable originPresentationState] == PresentationStateMedium) {
        yPos = presentable.mediumFormYPos;
    }

	UIView *panView = context.containerView.panContainerView ?: toVC.view;
	panView.frame = [context finalFrameForViewController:toVC];
	panView.hw_top = context.containerView.frame.size.height;

	if ([presentable isHapticFeedbackEnabled]) {
        if (@available(iOS 10.0, *)) {
            [self.feedbackGenerator selectionChanged];
        }
	}

	[HWPanModalAnimator animate:^{
		panView.hw_top = yPos;
	} config:presentable completion:^(BOOL completion) {
        
        if ([presentable shouldEnableAppearanceTransition]) {
            [fromVC endAppearanceTransition];
            [self endAppearanceTransitionForController:toVC];
        }
		
        if (@available(iOS 10.0, *)) {
            self.feedbackGenerator = nil;
        }

		[context completeTransition:completion];
	}];

	self.presentingVCTransitionContext = [[HWPresentingVCTransitionContext alloc] initWithFromVC:fromVC toVC:toVC duration:[presentable transitionDuration] containerView:context.containerView];
	[self presentAnimationForPresentingVC:presentable];
}

/**
 * 使弹出controller消失动画
 */
- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)context {

	UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
	if (!fromVC && !toVC)
		return;
    
    UIViewController<HWPanModalPresentable> *presentable = [self panModalViewController:context];

    
    if ([presentable shouldEnableAppearanceTransition]) {
        [self beginAppearanceTransitionForController:fromVC isAppearing:NO animated:YES];
        [toVC beginAppearanceTransition:YES animated:YES];
    }
	
	UIView *panView = context.containerView.panContainerView ?: fromVC.view;
    self.presentingVCTransitionContext = [[HWPresentingVCTransitionContext alloc] initWithFromVC:fromVC toVC:toVC duration:[presentable transitionDuration] containerView:context.containerView];

    // user toggle pan gesture to dismiss.
	if ([context isInteractive]) {
		[self interactionDismiss:context fromVC:fromVC toVC:toVC presentable:presentable panView:panView];
	} else {
		[self springDismiss:context fromVC:fromVC toVC:toVC presentable:presentable panView:panView];
	}
}

- (void)springDismiss:(id <UIViewControllerContextTransitioning>)context fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC presentable:(UIViewController <HWPanModalPresentable> *)presentable panView:(UIView *)panView {
	CGFloat offsetY = 0;
	HWPanModalShadow *shadowConfig = [presentable contentShadow];
	if (shadowConfig.shadowColor) {
		// we should make the panView move further to hide the shadow effect.
		offsetY = offsetY + shadowConfig.shadowRadius + shadowConfig.shadowOffset.height;
		if ([presentable showDragIndicator]) {
			offsetY += [presentable customIndicatorView] ? [presentable customIndicatorView].indicatorSize.height : 13;
		}
	}

	[HWPanModalAnimator dismissAnimate:^{
		[self dismissAnimationForPresentingVC:presentable];
		panView.hw_top = (context.containerView.frame.size.height + offsetY);
	} config:presentable completion:^(BOOL completion) {
		[fromVC.view removeFromSuperview];
        
        if ([presentable shouldEnableAppearanceTransition]) {
            [self endAppearanceTransitionForController:fromVC];
            [toVC endAppearanceTransition];
        }
		
		[context completeTransition:completion];
	}];
}

- (void)interactionDismiss:(id <UIViewControllerContextTransitioning>)context fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC presentable:(UIViewController <HWPanModalPresentable> *)presentable panView:(UIView *)panView {
	[HWPanModalAnimator smoothAnimate:^{
		if (self.interactiveMode == PanModalInteractiveModeSideslip) {
			panView.hw_left = panView.hw_width;
		}

		[self dismissAnimationForPresentingVC:presentable];
	} duration:[presentable dismissalDuration] completion:^(BOOL completion) {
		// 因为会有手势交互，所以需要判断transitions是否cancel
		BOOL finished = ![context transitionWasCancelled];

		if (finished) {
			[fromVC.view removeFromSuperview];
            
            if ([presentable shouldEnableAppearanceTransition]) {
                [self endAppearanceTransitionForController:fromVC];
                [toVC endAppearanceTransition];
            }
			
			context.containerView.userInteractionEnabled = YES;
		}
		[context completeTransition:finished];
	}];
}

#pragma mark - presenting VC animation

- (void)presentAnimationForPresentingVC:(UIViewController<HWPanModalPresentable> *)presentable {
	id<HWPresentingViewControllerAnimatedTransitioning> presentingAnimation = [self presentingVCAnimation:presentable];
	if (presentingAnimation) {
		[presentingAnimation presentAnimateTransition:self.presentingVCTransitionContext];
	}
}

- (void)dismissAnimationForPresentingVC:(UIViewController<HWPanModalPresentable> *)presentable {
    id<HWPresentingViewControllerAnimatedTransitioning> presentingAnimation = [self presentingVCAnimation:presentable];
    if (presentingAnimation) {
        [presentingAnimation dismissAnimateTransition:self.presentingVCTransitionContext];
    }
}

- (UIViewController <HWPanModalPresentable> *)panModalViewController:(id <UIViewControllerContextTransitioning>)context {
	switch (self.transitionStyle) {
		case TransitionStylePresentation: {
			UIViewController *controller = [context viewControllerForKey:UITransitionContextToViewControllerKey];
			if ([controller conformsToProtocol:@protocol(HWPanModalPresentable)]) {
				return (UIViewController <HWPanModalPresentable> *) controller;
			} else {
				return nil;
			}
		}
		case TransitionStyleDismissal: {
			UIViewController *controller = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
			if ([controller conformsToProtocol:@protocol(HWPanModalPresentable)]) {
				return (UIViewController <HWPanModalPresentable> *) controller;
			} else {
				return nil;
			}
		}
	}
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext { 
	switch (self.transitionStyle) {
		case TransitionStylePresentation: {
			[self animatePresentation:transitionContext];
		}
			break;
		case TransitionStyleDismissal: {
			[self animateDismissal:transitionContext];
		}
		default:
			break;
	}
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
	if (transitionContext && [self panModalViewController:transitionContext]) {
		UIViewController<HWPanModalPresentable> *controller = [self panModalViewController:transitionContext];
		return [controller transitionDuration];
	}
	return kTransitionDuration;
}

#pragma mark - presenting animated transition

- (id<HWPresentingViewControllerAnimatedTransitioning>)presentingVCAnimation:(UIViewController<HWPanModalPresentable> *)presentable {
	switch ([presentable presentingVCAnimationStyle]) {
		case PresentingViewControllerAnimationStylePageSheet:
			return [HWPageSheetPresentingAnimation new];
		case PresentingViewControllerAnimationStyleShoppingCart:
			return [HWShoppingCartPresentingAnimation new];
		case PresentingViewControllerAnimationStyleCustom:
			return [presentable customPresentingVCAnimation];
		default:
			return nil;
	}
}

#pragma mark - private method

- (void)beginAppearanceTransitionForController:(UIViewController *)viewController isAppearing:(BOOL)isAppearing animated:(BOOL)animated {
    // Fix `The unbalanced calls to begin/end appearance transitions` warning.
    if (![viewController isKindOfClass:UINavigationController.class]) {
        [viewController beginAppearanceTransition:isAppearing animated:animated];
    }
}

- (void)endAppearanceTransitionForController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:UINavigationController.class]) {
        [viewController endAppearanceTransition];
    }
}

@end

@implementation HWPresentingVCTransitionContext

- (instancetype)initWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC duration:(NSTimeInterval)duration containerView:(UIView *)containerView {
	self = [super init];
	if (self) {
		_fromVC = fromVC;
		_toVC = toVC;
		_duration = duration;
		_containerView = containerView;
	}

	return self;
}


- (__kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key {
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromVC;
    } else if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        return self.toVC;
    }
	return nil;
}

- (NSTimeInterval)transitionDuration {
	return self.duration;
}

@end
