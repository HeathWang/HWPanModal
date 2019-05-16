//
//  HWPickerViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/16.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWPickerViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWPickerViewController () <HWPanModalPresentable>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation HWPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.datePicker];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.confirmButton);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.cancelButton);
    }];

    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.confirmButton.mas_bottom).offset(20);
    }];
}

#pragma mark - HWPanModalPresentable

- (BOOL)shouldRoundTopCorners {
    return NO;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 276);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint loc = [panGestureRecognizer locationInView:self.view];
    return !CGRectContainsPoint(self.datePicker.frame, loc);

}

- (BOOL)allowsTapBackgroundToDismiss {
    return NO;
}

#pragma mark - touch event

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doneAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Getter

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.371 green:0.371 blue:0.371 alpha:1.00] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"Done" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithRed:0.000 green:0.590 blue:1.000 alpha:1.00] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [UIDatePicker new];
    }
    return _datePicker;
}


@end
