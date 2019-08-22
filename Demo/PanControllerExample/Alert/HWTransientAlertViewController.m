//
//  HWTransientAlertViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWTransientAlertViewController.h"
#import "HWAlertView.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWTransientAlertViewController () <HWPanModalPresentable>

@end

@implementation HWTransientAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - HWPanModalPresentable

- (CGFloat)backgroundAlpha {
    return 0;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)anchorModalToLongForm {
    return YES;
}

- (BOOL)isUserInteractionEnabled {
    return NO;
}

@end
