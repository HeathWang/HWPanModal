//
//  HWPageSheetPresentingAnimation.m
//  HWPanModal-iOS10.0
//
//  Created by heath wang on 2019/9/5.
//

#import "HWPageSheetPresentingAnimation.h"

@implementation HWPageSheetPresentingAnimation

- (void)presentAnimateTransition:(nonnull id <HWPresentingViewControllerContextTransitioning>)context {
    NSTimeInterval duration = [context transitionDuration];
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat scale = 1 - statusBarHeight * 2 / CGRectGetHeight(fromVC.view.bounds);
        fromVC.view.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {

    }];
}

- (void)dismissAnimateTransition:(nonnull id <HWPresentingViewControllerContextTransitioning>)context {
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.transform = CGAffineTransformIdentity;
}

@end
