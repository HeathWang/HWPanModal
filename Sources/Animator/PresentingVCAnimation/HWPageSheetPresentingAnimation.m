//
//  HWPageSheetPresentingAnimation.m
//  HWPanModal-iOS10.0
//
//  Created by heath wang on 2019/9/5.
//

#import "HWPageSheetPresentingAnimation.h"

@implementation HWPageSheetPresentingAnimation

- (void)presentAnimateTransition:(nonnull id <HWPresentingViewControllerContextTransitioning>)context {
    NSTimeInterval duration = [context mainTransitionDuration];
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {

    }];
}

- (void)dismissAnimateTransition:(nonnull id <HWPresentingViewControllerContextTransitioning>)context {
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.transform = CGAffineTransformIdentity;
}


@end
