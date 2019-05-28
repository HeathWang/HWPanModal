//
//  HWNavViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWNavViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "HWUserGroupViewController.h"

@interface HWNavViewController () <HWPanModalPresentable>

@end

@implementation HWNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HWUserGroupViewController *userGroupViewController = [HWUserGroupViewController new];
    [self pushViewController:userGroupViewController animated:YES];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
}

#pragma mark - HWPanModalPresentable

- (UIScrollView *)panScrollable {
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        id<HWPanModalPresentable> obj = VC;
        return [obj panScrollable];
    }
    return nil;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (BOOL)showDragIndicator {
    return NO;
}


@end
