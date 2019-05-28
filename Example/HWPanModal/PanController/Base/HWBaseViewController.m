//
//  HWBaseViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/4/30.
//  Copyright © 2019 HeathWang. All rights reserved.
//

#import <HWPanModal/HWPanModal.h>
#import "HWBaseViewController.h"

@interface HWBaseViewController () <HWPanModalPresentable>

@end

@implementation HWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.000 green:0.989 blue:0.935 alpha:1.00];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}

- (PanModalHeight)shortFormHeight {
    if ([self isLandScape]) {
        return [self longFormHeight];
    }
    return PanModalHeightMake(PanModalHeightTypeContent, 200);
}


// 当转屏且为横屏时，为全屏幕模式。
- (CGFloat)topOffset {
    if ([self isLandScape]) {
        return 0;
    } else {
        return 40;
    }
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (UIViewAnimationOptions)transitionAnimationOptions {
    return UIViewAnimationOptionCurveLinear;
}

- (BOOL)isLandScape {
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    return NO;
}


@end
