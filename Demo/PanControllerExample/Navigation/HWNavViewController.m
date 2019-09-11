//
//  HWNavViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWNavViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "HWFetchDataViewController.h"

@interface HWNavViewController () <HWPanModalPresentable>

@end

@implementation HWNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    HWFetchDataViewController *fetchDataVC = [HWFetchDataViewController new];
    [self pushViewController:fetchDataVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (CGFloat)topOffset {
    return 0;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, [UIApplication sharedApplication].statusBarFrame.size.height + 20);
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStylePageSheet;
}


@end
