//
//  UINavigationController+HWPanModal.m
//  HWPanModal
//
//  Created by heath wang on 2019/8/16.
//

#import "UINavigationController+HWPanModal.h"
#import "NSObject+HW_Swizzle.h"
#import "UIViewController+Presentation.h"

@implementation UINavigationController (HWPanModal)

+ (void)initialize {
    if (self == [UINavigationController self]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self hw_swizzleInstanceMethod:@selector(pushViewController:animated:) with:@selector(hw_pushViewController:animated:)];
            [self hw_swizzleInstanceMethod:@selector(popViewControllerAnimated:) with:@selector(hw_popViewControllerAnimated:)];
            [self hw_swizzleInstanceMethod:@selector(popToViewController:animated:) with:@selector(hw_popToViewController:animated:)];
            [self hw_swizzleInstanceMethod:@selector(hw_popToRootViewControllerAnimated:) with:@selector(hw_popToRootViewControllerAnimated:)];
        });
    }
}

- (void)hw_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self hw_pushViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
}

- (UIViewController *)hw_popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [self hw_popViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (NSArray<UIViewController *> *)hw_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *> *controllers = [self hw_popToViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controllers;
}

- (NSArray<UIViewController *> *)hw_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *controllers = [self hw_popToRootViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controllers;
}

@end
