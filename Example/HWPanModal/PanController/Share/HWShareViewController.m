//
//  HWShareViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/28.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWShareViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWShareViewController () <HWPanModalPresentable>

@property (nonatomic, strong) UIImageView *shareIMGView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation HWShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shareIMGView];
    [self.view addSubview:self.cancelButton];

    [self.shareIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.centerX.equalTo(@0);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.mas_equalTo(46);
    }];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 300);
}

- (BOOL)showDragIndicator {
    return NO;
}

#pragma mark - touch action

- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - Getter

- (UIImageView *)shareIMGView {
    if (!_shareIMGView) {
        _shareIMGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_share_item"]];
    }
    return _shareIMGView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor colorWithRed:0.976 green:0.980 blue:0.980 alpha:1.00]];
        [_cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


@end
