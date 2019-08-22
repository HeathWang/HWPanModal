//
//  HWMyCustomAnimationViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/6/12.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWMyCustomAnimationViewController.h"
#import <HWPanModal/HWPanModal.h>

// define object conforms HWPresentingViewControllerAnimatedTransitioning
@interface HWMyCustomAnimation : NSObject <HWPresentingViewControllerAnimatedTransitioning>

@end

@interface HWMyCustomAnimationViewController () <HWPanModalPresentable>

@property (nonatomic, strong) HWMyCustomAnimation *customAnimation;

@end

@implementation HWMyCustomAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.600 green:1.000 blue:0.600 alpha:1.00];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 84);
}

- (CGFloat)topOffset {
    return 0;
}


- (BOOL)shouldAnimatePresentingVC {
    return YES;
}

- (id<HWPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation {
    return self.customAnimation;
}

- (void)panModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent {
    CGFloat scale = 0.9 + percent * 0.1;
    self.presentingViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
}

- (HWMyCustomAnimation *)customAnimation {
    if (!_customAnimation) {
        _customAnimation = [HWMyCustomAnimation new];
    }
    return _customAnimation;
}

@end

@implementation HWMyCustomAnimation


- (void)presentAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [transitionContext mainTransitionDuration];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [transitionContext mainTransitionDuration];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [UIView animateWithDuration:duration animations:^{
        toVC.view.transform = CGAffineTransformIdentity;
    }];
}

@end
