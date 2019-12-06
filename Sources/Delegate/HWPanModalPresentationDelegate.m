//
//  HWPanModalPresentationDelegate.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "HWPanModalPresentationDelegate.h"
#import "HWPanModalPresentationAnimator.h"
#import "HWPanModalPresentationController.h"
#import "HWPanModalInteractiveAnimator.h"

@interface HWPanModalPresentationDelegate ()

@property (nonatomic, strong) HWPanModalInteractiveAnimator *interactiveDismissalAnimator;

@end

@implementation HWPanModalPresentationDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	return [[HWPanModalPresentationAnimator alloc] initWithTransitionStyle:TransitionStylePresentation interactiveMode:PanModalInteractiveModeNone];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return [[HWPanModalPresentationAnimator alloc] initWithTransitionStyle:TransitionStyleDismissal interactiveMode:self.interactiveMode];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
	if (self.interactive) {
		return self.interactiveDismissalAnimator;
	}

	return nil;
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

#pragma mark - Getter

- (HWPanModalInteractiveAnimator *)interactiveDismissalAnimator {
	if (!_interactiveDismissalAnimator) {
		_interactiveDismissalAnimator = [[HWPanModalInteractiveAnimator alloc] init];
	}
	return _interactiveDismissalAnimator;
}

#ifdef DEBUG

- (void)dealloc {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

#endif

@end
