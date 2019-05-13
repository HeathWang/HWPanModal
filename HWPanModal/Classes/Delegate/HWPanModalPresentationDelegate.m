//
//  HWPanModalPresentationDelegate.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "HWPanModalPresentationDelegate.h"
#import "HWPanModalPresentationAnimator.h"
#import "HWPanModalPresentationController.h"

@implementation HWPanModalPresentationDelegate

+ (instancetype)sharedInstance
{
    static HWPanModalPresentationDelegate *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	return [[HWPanModalPresentationAnimator alloc] initWithTransitionStyle:TransitionStylePresentation];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return [[HWPanModalPresentationAnimator alloc] initWithTransitionStyle:TransitionStyleDismissal];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
	UIPresentationController *controller = [[HWPanModalPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
	controller.delegate = self;
	return controller;
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
	return UIModalPresentationNone;
}


@end
