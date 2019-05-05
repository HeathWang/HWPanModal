//
//  UIViewController+PanModalPresenter.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+PanModalPresenter.h"
#import "HWPanModalPresentationDelegate.h"

@implementation UIViewController (PanModalPresenter)

- (BOOL)isPanModalPresented {
	return [self.transitioningDelegate isKindOfClass:HWPanModalPresentationDelegate.class];
}

- (void)presentPanModal:(UIViewController <HWPanModalPresentable> *)viewControllerToPresent sourceView:(nullable UIView *)sourceView sourceRect:(CGRect)rect {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		// TODO: 稍后处理ipad
	} else {

		viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
		viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = YES;
		viewControllerToPresent.transitioningDelegate = [HWPanModalPresentationDelegate sharedInstance];
	}

	[self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)presentPanModal:(UIViewController <HWPanModalPresentable> *)viewControllerToPresent {
	[self presentPanModal:viewControllerToPresent sourceView:nil sourceRect:CGRectZero];
}


@end
