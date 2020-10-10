//
//  HWBlurViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/6/14.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWBlurViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface HWBlurViewController () <HWPanModalPresentable>

@end

@implementation HWBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.400 blue:1.000 alpha:1.00];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 150);
}

- (HWBackgroundConfig *)backgroundConfig {
    HWBackgroundConfig *backgroundConfig;
    
    if (@available(iOS 14.0, *)) {
        backgroundConfig = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorSystemVisualEffect];
    } else {
        backgroundConfig = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorCustomBlurEffect];
        backgroundConfig.backgroundBlurRadius = 15;
    }
    
    return backgroundConfig;
}

@end
