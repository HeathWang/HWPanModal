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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 200);
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (UIViewAnimationOptions)transitionAnimationOptions {
    return UIViewAnimationOptionCurveLinear;
}


@end
