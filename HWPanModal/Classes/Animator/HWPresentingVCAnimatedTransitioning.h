//
//  HWCustomPresentingVCAnimatedTransitioning.h
//  HWPanModal
//
//  Created by heath wang on 2019/6/12.
//

#ifndef HWCustomPresentingVCAnimatedTransitioning_h
#define HWCustomPresentingVCAnimatedTransitioning_h

@protocol HWPresentingViewControllerContextTransitioning <NSObject>

/**
 * Returns a view controller involved in the transition.
 * @return The view controller object for the specified key or nil if the view controller could not be found.
 */
- (__kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key;

/**
 * The Animation duration gets from ViewController which conforms HWPanModalPresentable
 * - (NSTimeInterval)transitionDuration;
 */
- (NSTimeInterval)mainTransitionDuration;

/**
 * Transition container, from UIViewControllerContextTransitioning protocol
 */
@property(nonatomic, readonly) UIView *containerView;

@end

@protocol HWPresentingViewControllerAnimatedTransitioning <NSObject>

/**
 * Write you custom animation when present.
 */
- (void)presentAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext;
/**
 * Write you custom animation when dismiss.
 */
- (void)dismissAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext;

@end


#endif /* HWCustomPresentingVCAnimatedTransitioning_h */



