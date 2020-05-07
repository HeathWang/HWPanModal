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

#pragma mark - HWPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 200.00001);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (CGFloat)topOffset {
    return self.topLayoutOffset;
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (HWPanModalShadow)contentShadow {
    return PanModalShadowMake([UIColor yellowColor], 10, CGSizeMake(0, 2), 1);
}

- (UIViewAnimationOptions)transitionAnimationOptions {
    return UIViewAnimationOptionCurveLinear;
}

- (BOOL)showDragIndicator {
    return NO;
}

#ifdef DEBUG

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#endif


@end
