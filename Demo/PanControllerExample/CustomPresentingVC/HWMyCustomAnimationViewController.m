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

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return  UIStatusBarStyleLightContent;
//}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 84);
}

- (CGFloat)topOffset {
    return 0;
}


- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStyleCustom;
}

- (id<HWPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation {
    return self.customAnimation;
}

- (HWMyCustomAnimation *)customAnimation {
    if (!_customAnimation) {
        _customAnimation = [HWMyCustomAnimation new];
    }
    return _customAnimation;
}

@end

@implementation HWMyCustomAnimation


- (void)presentAnimateTransition:(nonnull id <HWPresentingViewControllerContextTransitioning>)context {
    NSTimeInterval duration = [context transitionDuration];
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAnimateTransition:(nonnull id <HWPresentingViewControllerContextTransitioning>)context {
    // no need for using animating block.
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.transform = CGAffineTransformIdentity;
}

@end
