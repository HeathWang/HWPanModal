//
//  HWPanModalAnimator.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWPanModalAnimator.h"

@implementation HWPanModalAnimator

+ (void)animate:(AnimationBlockType)animations config:(nullable id<HWPanModalPresentable>)config completion:(AnimationCompletionType)completion {
	NSTimeInterval duration = config ? [config transitionDuration] : kTransitionDuration;
	CGFloat springDamping = config ? [config springDamping] : 1.0;
	UIViewAnimationOptions options = config ? [config transitionAnimationOptions] : UIViewAnimationOptionPreferredFramesPerSecondDefault;

	[UIView animateWithDuration:duration delay:0 usingSpringWithDamping:springDamping initialSpringVelocity:0 options:options animations:animations completion:completion];
}

@end
