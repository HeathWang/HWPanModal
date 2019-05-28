//
//  HWDynamicHeightViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/17.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWDynamicHeightViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

typedef NS_ENUM(NSInteger, ChangeHeightType) {
	ChangeHeightTypeShort,
	ChangeHeightTypeLong,
};

@interface HWDynamicHeightViewController () <HWPanModalPresentable>

@property (nonatomic, strong) UIButton *changeShortButton;
@property (nonatomic, strong) UIButton *changeLongButton;

@property (nonatomic, assign) PanModalHeight shortHeight;
@property (nonatomic, assign) PanModalHeight longHeight;
@property (nonatomic, assign) ChangeHeightType currentType;

@end

@implementation HWDynamicHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.542 green:0.740 blue:0.082 alpha:1.00];
	[self.view addSubview:self.changeShortButton];
	[self.view addSubview:self.changeLongButton];

	[self.changeShortButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(@20);
		make.right.equalTo(@-20);
		make.top.equalTo(@20);
		make.height.mas_equalTo(44);
	}];

	[self.changeLongButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.equalTo(self.changeShortButton);
		make.left.equalTo(self.changeShortButton);
		make.top.equalTo(self.changeShortButton.mas_bottom).offset(20);
	}];
}

#pragma mark - touch event

- (void)onTapChangeShort {
	self.currentType = ChangeHeightTypeShort;
	[self hw_panModalSetNeedsLayoutUpdate];
    [self hw_panModalTransitionTo:PresentationStateShort];
}

- (void)onTapChangeLong {
	self.currentType = ChangeHeightTypeLong;
	[self hw_panModalSetNeedsLayoutUpdate];
	[self hw_panModalTransitionTo:PresentationStateLong];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)shortFormHeight {
	if (self.currentType == ChangeHeightTypeShort) {
		CGFloat height = arc4random() % 250 + 100;
		self.shortHeight = PanModalHeightMake(PanModalHeightTypeMaxTopInset, height);
	}

	return self.shortHeight;
}

- (PanModalHeight)longFormHeight {
	if (self.currentType == ChangeHeightTypeLong) {
		CGFloat height = arc4random() % 150;
		self.longHeight = PanModalHeightMake(PanModalHeightTypeMaxTopInset, height);
	}

	return self.longHeight;
}

#pragma mark - private method

- (UIButton *)buttonWithTitle:(NSString *)title {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor whiteColor];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.layer.masksToBounds = YES;
	button.layer.cornerRadius = 8;

	return button;
}

#pragma mark - Getter

- (UIButton *)changeShortButton {
	if (!_changeShortButton) {
		_changeShortButton = [self buttonWithTitle:@"Dynamic Change short Form Height"];
		[_changeShortButton addTarget:self action:@selector(onTapChangeShort) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeShortButton;
}

- (UIButton *)changeLongButton {
	if (!_changeLongButton) {
		_changeLongButton = [self buttonWithTitle:@"Dynamic Change long Form Height"];
		[_changeLongButton addTarget:self action:@selector(onTapChangeLong) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeLongButton;
}


@end
