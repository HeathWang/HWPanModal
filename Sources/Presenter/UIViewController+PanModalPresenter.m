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

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent sourceView:(UIView *)sourceView sourceRect:(CGRect)rect completion:(void (^)(void))completion {
    
    HWPanModalPresentationDelegate *delegate = [HWPanModalPresentationDelegate new];
    viewControllerToPresent.hw_panModalPresentationDelegate = delegate;

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
        [self presentViewController:viewControllerToPresent animated:YES completion:completion];
    });
}

- (void)presentPanModal:(UIViewController <HWPanModalPresentable> *)viewControllerToPresent sourceView:(nullable UIView *)sourceView sourceRect:(CGRect)rect {
    [self presentPanModal:viewControllerToPresent sourceView:sourceView sourceRect:rect completion:nil];

}

- (void)presentPanModal:(UIViewController <HWPanModalPresentable> *)viewControllerToPresent {
	[self presentPanModal:viewControllerToPresent sourceView:nil sourceRect:CGRectZero];
}

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent completion:(void (^)(void))completion {
    [self presentPanModal:viewControllerToPresent sourceView:nil sourceRect:CGRectZero completion:completion];
}

- (HWPanModalPresentationDelegate *)hw_panModalPresentationDelegate {
	return objc_getAssociatedObject(self, _cmd);
}

- (void)setHw_panModalPresentationDelegate:(HWPanModalPresentationDelegate *)hw_panModalPresentationDelegate {
	objc_setAssociatedObject(self, @selector(hw_panModalPresentationDelegate), hw_panModalPresentationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
