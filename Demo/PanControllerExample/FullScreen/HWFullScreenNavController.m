//
//  HWFullScreenNavController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/13.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWFullScreenNavController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWFullScreenViewController : UIViewController

@end

@interface HWFullScreenNavController () <HWPanModalPresentable>

@end

@implementation HWFullScreenNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pushViewController:[HWFullScreenViewController new] animated:NO];
}

#pragma mark - overridden to update panModal

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

#pragma mark - HWPanModalPresentable

- (CGFloat)topOffset {
    return 0;
}

- (NSTimeInterval)transitionDuration {
    return 0.4;
}

- (CGFloat)springDamping {
    return 1;
}

- (BOOL)shouldRoundTopCorners {
    return NO;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction {
    return 0;
}

// if you use some framework like FDFullscreenPopGesture, follow this code.
/*
- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self.fd_fullscreenPopGestureRecognizer.state == UIGestureRecognizerStateBegan || self.fd_fullscreenPopGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return NO;
    }
    return YES;
}
 */

@end


@implementation HWFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"Full Screen";

    UILabel *label = [UILabel new];
    label.text = @"Drag to Dismiss!";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"NEXT" style:UIBarButtonItemStylePlain target:self action:@selector(nextPage)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)nextPage {
	HWFullScreenViewController *pageOneViewController = [HWFullScreenViewController new];
	[self.navigationController pushViewController:pageOneViewController animated:YES];
}


@end
