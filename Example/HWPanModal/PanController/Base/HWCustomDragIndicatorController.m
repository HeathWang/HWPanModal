//
//  HWCustomDragIndicatorController.m
//  HWPanModal_Example
//
//  Created by politom on 08/08/2019.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWCustomDragIndicatorController.h"
#import "HWPanIndicatorView.h"
#import "HWCustomPanIndicatorView.h"

@interface HWCustomDragIndicatorController ()

@end

@implementation HWCustomDragIndicatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 * Allow to customize drag indicator
 */
- (HWPanIndicatorView*)customDragIndicator {
    return [HWCustomPanIndicatorView new];
}

@end


