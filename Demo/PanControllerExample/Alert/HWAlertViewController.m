//
//  HWAlertViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWAlertViewController.h"
#import "HWAlertView.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWAlertViewController () <HWPanModalPresentable>

@property (nonatomic, strong) HWAlertView *alertView;

@end

@implementation HWAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.top.equalTo(@0);
        make.height.mas_equalTo(kAlertHeight);
    }];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, kAlertHeight);
}

- (PanModalHeight)longFormHeight {
    return [self shortFormHeight];
}

- (CGFloat)backgroundAlpha {
    return 0.1;
}

- (BOOL)shouldRoundTopCorners {
    return NO;
}

- (BOOL)showDragIndicator {
    return YES;
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (BOOL)isUserInteractionEnabled {
    
    return YES;
}

#pragma mark - Getter

- (HWAlertView *)alertView {
    if (!_alertView) {
        _alertView = [HWAlertView new];
        _alertView.layer.cornerRadius = 8;
    }
    return _alertView;
}


@end
