//
//  UIViewController+PanModalPresenter.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+PanModalPresenter.h"
#import "HWPanModalPresentationDelegate.h"
#import <objc/runtime.h>

@implementation UIViewController (PanModalPresenter)

- (BOOL)isPanModalPresented {
	return [self.transitioningDelegate isKindOfClass:HWPanModalPresentationDelegate.class];
}

- (void)presentPanModal:(UIViewController <HWPanModalPresentable> *)viewControllerToPresent sourceView:(nullable UIView *)sourceView sourceRect:(CGRect)rect {
	HWPanModalPresentationDelegate *delegate = [HWPanModalPresentationDelegate new];
	viewControllerToPresent.presentationDelegate = delegate;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad &&
        (sourceView && !CGRectEqualToRect(rect, CGRectZero))) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationPopover;
        viewControllerToPresent.popoverPresentationController.sourceRect = rect;
        viewControllerToPresent.popoverPresentationController.sourceView = sourceView;
        viewControllerToPresent.popoverPresentationController.delegate = delegate;
    } else {

        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = YES;
        viewControllerToPresent.transitioningDelegate = delegate;
    }
    
    // fix for iOS 8 issue: the present action will delay.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    });

}

- (void)presentPanModal:(UIViewController <HWPanModalPresentable> *)viewControllerToPresent {
	[self presentPanModal:viewControllerToPresent sourceView:nil sourceRect:CGRectZero];
}

- (HWPanModalPresentationDelegate *)presentationDelegate {
	return objc_getAssociatedObject(self, _cmd);
}

- (void)setPresentationDelegate:(HWPanModalPresentationDelegate *)presentationDelegate {
	objc_setAssociatedObject(self, @selector(presentationDelegate), presentationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
