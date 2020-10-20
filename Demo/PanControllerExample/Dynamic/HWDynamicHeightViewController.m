//
//  HWDynamicHeightViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/17.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWDynamicHeightViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

typedef NS_ENUM(NSInteger, ChangeHeightType) {
	ChangeHeightTypeShort,
	ChangeHeightTypeLong,
};

@interface HWDynamicHeightViewController () <HWPanModalPresentable>

// height
@property (nonatomic, strong) UIButton *changeShortButton;
@property (nonatomic, strong) UIButton *changeLongButton;

// shadow
@property (nonatomic, strong) UIButton *changeShadowButton;
@property (nonatomic, strong) UIButton *clearShadowButton;

@property (nonatomic, assign) HWPanModalShadow shadowConfig;

// corner
@property (nonatomic, strong) UIButton *changeRoundCornerButton;
@property (nonatomic, strong) UIButton *clearRoundCornerButton;

// background

@property (nonatomic, strong) UIButton *changeBackgroundButton;

@property (nonatomic, assign) CGFloat roundRadius;
@property (nonatomic, assign) BOOL shouldRound;

@property (nonatomic, strong) UISwitch *indicatorSwitch;

@property (nonatomic, assign) PanModalHeight shortHeight;
@property (nonatomic, assign) PanModalHeight longHeight;
@property (nonatomic, assign) ChangeHeightType currentType;
@property (nonatomic, assign) BOOL bgFlag;

@end

@implementation HWDynamicHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.800 blue:1.000 alpha:1.00];
	[self.view addSubview:self.changeShortButton];
	[self.view addSubview:self.changeLongButton];


	[self.changeShortButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(@20);
		make.top.equalTo(@20);
		make.height.mas_equalTo(44);
		make.size.equalTo(@[self.changeLongButton]);
	}];

	[self.changeLongButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.changeShortButton.mas_right).offset(20);
		make.top.equalTo(self.changeShortButton);
		make.right.equalTo(@-20);
	}];

	[self.view addSubview:self.changeShadowButton];
	[self.view addSubview:self.clearShadowButton];
	[self.changeShadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(44);
		make.size.equalTo(@[self.clearShadowButton]);
		make.left.equalTo(self.changeShortButton);
		make.top.equalTo(self.changeShortButton.mas_bottom).offset(20);
	}];

	[self.clearShadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.changeShadowButton.mas_right).offset(20);
		make.top.equalTo(self.changeShadowButton);
		make.right.equalTo(@-20);
	}];
    
    [self.view addSubview:self.changeRoundCornerButton];
    [self.view addSubview:self.clearRoundCornerButton];
    
    [self.changeRoundCornerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.size.equalTo(@[self.clearRoundCornerButton]);
        make.left.equalTo(self.changeShortButton);
        make.top.equalTo(self.clearShadowButton.mas_bottom).offset(20);
    }];
    
    [self.clearRoundCornerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.changeRoundCornerButton.mas_right).offset(20);
        make.top.equalTo(self.changeRoundCornerButton);
        make.right.equalTo(@-20);
    }];
    
    [self.view addSubview:self.changeBackgroundButton];
    
    [self.changeBackgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.changeShortButton);
        make.top.equalTo(self.clearRoundCornerButton.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
        make.right.equalTo(@-20);
    }];

	[self.view addSubview:self.indicatorSwitch];
	[self.indicatorSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(@0);
		make.top.equalTo(self.changeBackgroundButton.mas_bottom).offset(20);
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

- (void)onTapDefaultShadow {
	self.shadowConfig = PanModalShadowMake([UIColor blueColor], 8, CGSizeMake(0, 2), 1);
	[self hw_panModalSetNeedsLayoutUpdate];
}

- (void)onTapClearShadow {
	self.shadowConfig = PanModalShadowNil();
	[self hw_panModalSetNeedsLayoutUpdate];
}

- (void)onTapChangeRoundCorner {
	self.roundRadius = 12;
    self.shouldRound = YES;
	[self hw_panModalSetNeedsLayoutUpdate];
}

- (void)onTapClearRoundCorner {
	self.shouldRound = NO;
	[self hw_panModalSetNeedsLayoutUpdate];
}

- (void)onTapChangeIndicator {
	[self hw_panModalSetNeedsLayoutUpdate];
}

- (void)onTapChangeBG {
    self.bgFlag = !self.bgFlag;
    HWBackgroundConfig *config = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
    if (self.bgFlag) {
        config = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
        config.backgroundAlpha = 0.15;
    } else {
        config.backgroundAlpha = 0.7;
    }
    [self.hw_dimmedView reloadConfig:config];
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

- (HWPanModalShadow)contentShadow {
	return self.shadowConfig;
}

- (BOOL)shouldRoundTopCorners {
	return self.shouldRound;
}

- (CGFloat)cornerRadius {
	return self.roundRadius;
}

- (BOOL)showDragIndicator {
	return self.indicatorSwitch.on;
}

//- (HWBackgroundConfig *)backgroundConfig {
//    if (self.bgFlag) {
//        HWBackgroundConfig *config = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
//        config.backgroundAlpha = 0;
//        return config;
//    } else {
//        HWBackgroundConfig *config = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
//        config.backgroundAlpha = 0.7;
//        return config;
//    }
//}

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
		_changeShortButton = [self buttonWithTitle:@"Short Form Height"];
		[_changeShortButton addTarget:self action:@selector(onTapChangeShort) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeShortButton;
}

- (UIButton *)changeLongButton {
	if (!_changeLongButton) {
		_changeLongButton = [self buttonWithTitle:@"Long Form Height"];
		[_changeLongButton addTarget:self action:@selector(onTapChangeLong) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeLongButton;
}

- (UIButton *)changeShadowButton {
	if (!_changeShadowButton) {
		_changeShadowButton = [self buttonWithTitle:@"Default Shadow"];
		[_changeShadowButton addTarget:self action:@selector(onTapDefaultShadow) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeShadowButton;
}

- (UIButton *)clearShadowButton {
	if (!_clearShadowButton) {
		_clearShadowButton = [self buttonWithTitle:@"Clear Shadow"];
		[_clearShadowButton addTarget:self action:@selector(onTapClearShadow) forControlEvents:UIControlEventTouchUpInside];
	}
	return _clearShadowButton;
}

- (UIButton *)changeRoundCornerButton {
	if (!_changeRoundCornerButton) {
		_changeRoundCornerButton = [self buttonWithTitle:@"Corner 4"];
		[_changeRoundCornerButton addTarget:self action:@selector(onTapChangeRoundCorner) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeRoundCornerButton;
}

- (UIButton *)clearRoundCornerButton {
	if (!_clearRoundCornerButton) {
		_clearRoundCornerButton = [self buttonWithTitle:@"Corner 0"];
		[_clearRoundCornerButton addTarget:self action:@selector(onTapClearRoundCorner) forControlEvents:UIControlEventTouchUpInside];
	}
	return _clearRoundCornerButton;
}


- (UISwitch *)indicatorSwitch {
	if (!_indicatorSwitch) {
		_indicatorSwitch = [UISwitch new];
		[_indicatorSwitch addTarget:self action:@selector(onTapChangeIndicator) forControlEvents:UIControlEventValueChanged];
	}
	return _indicatorSwitch;
}

- (UIButton *)changeBackgroundButton {
    if (!_changeBackgroundButton) {
        _changeBackgroundButton = [self buttonWithTitle:@"Change background alpha"];
        [_changeBackgroundButton addTarget:self action:@selector(onTapChangeBG) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeBackgroundButton;
}


@end
