//
//  HWPanModalNavView.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/12/16.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HWPanModalNavView.h"

@interface HWPanModalNavView ()

@property (nonatomic, strong) UIView *navContentView;
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation HWPanModalNavView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }

    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.navContentView];
    [self.navContentView addSubview:self.navTitleLabel];
    [self.navContentView addSubview:self.backButton];
    [self.navContentView addSubview:self.rightButton];
    [self setupViewConstraints];
}

- (void)setupViewConstraints {

    [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(self.statusBarHeight));
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.bottom.equalTo(@0);
        make.width.mas_equalTo(66);
    }];

    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.top.bottom.equalTo(@0);
        make.width.mas_equalTo(66);
    }];

    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(10);
        make.right.equalTo(self.rightButton.mas_left).offset(-10);
        make.bottom.top.equalTo(@0);
    }];

}

#pragma mark - touch action

- (void)onTappedBackButton {
    id <HWPanModalNavViewDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(didTapBackButton)]) {
        [o didTapBackButton];
    }
}

- (void)onTappedRightButton {
    id <HWPanModalNavViewDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(didTapRightButton)]) {
        [o didTapRightButton];
    }
}

#pragma mark - Getter

- (UIView *)navContentView {
    if (!_navContentView) {
        _navContentView = [UIView new];
    }
    return _navContentView;
}

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [UILabel new];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.textColor = [UIColor darkTextColor];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    }

    return _navTitleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_backButton addTarget:self action:@selector(onTappedBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"Done" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightButton addTarget:self action:@selector(onTappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - Setter

- (void)setStatusBarHeight:(CGFloat)statusBarHeight {
    _statusBarHeight = statusBarHeight;

    [self.navContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.statusBarHeight));
    }];
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    _title = [title mutableCopy];
    self.navTitleLabel.text = title;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = [rightButtonTitle mutableCopy];

    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
}

- (void)setBackButtonTitle:(NSString *)backButtonTitle {
    _backButtonTitle = [backButtonTitle mutableCopy];

    [self.backButton setTitle:backButtonTitle forState:UIControlStateNormal];
    self.backButton.hidden = backButtonTitle.length <= 0;
}


@end
