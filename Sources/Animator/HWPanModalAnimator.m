//
//  HWPanModalAnimator.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWPanModalAnimator.h"

@implementation HWPanModalAnimator

+ (void)animate:(AnimationBlockType)animations config:(nullable id<HWPanModalPresentable>)config completion:(AnimationCompletionType)completion {
	[HWPanModalAnimator animate:animations config:config startingFromPercent:1 isPresentation:YES completion:completion];
}

+ (void)dismissAnimate:(AnimationBlockType)animations config:(nullable id<HWPanModalPresentable>)config completion:(AnimationCompletionType)completion {
    [HWPanModalAnimator animate:animations config:config startingFromPercent:1 isPresentation:NO completion:completion];
}

+ (void)animate:(AnimationBlockType)animations config:(nullable id <HWPanModalPresentable>)config startingFromPercent:(CGFloat)animationPercent isPresentation:(BOOL)flag completion:(AnimationCompletionType)completion {

    NSTimeInterval duration;
    if  (flag) {
        duration = config ? [config transitionDuration] : kTransitionDuration;
    } else {
        duration = config ? [config dismissalDuration] : kTransitionDuration;
    }

    duration = duration * MAX(animationPercent, 0);
    CGFloat springDamping = config ? [config springDamping] : 1.0;
    UIViewAnimationOptions options = config ? [config transitionAnimationOptions] : UIViewAnimationOptionPreferredFramesPerSecondDefault;

    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:springDamping initialSpringVelocity:0 options:options animations:animations completion:completion];
}

+ (void)smoothAnimate:(AnimationBlockType)animations duration:(NSTimeInterval)duration completion:(nullable AnimationCompletionType)completion {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:animations completion:completion];
}

@end
