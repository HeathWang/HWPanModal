//
//  HWColorDetailViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWColorDetailViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWColorDetailViewController () <HWPanModalPresentable>

@end

@implementation HWColorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Detail";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [UIView new];
    view.backgroundColor = self.color;
	[self.view addSubview:view];
	[view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(200, 200));
		make.top.equalTo(@88);
		make.centerX.equalTo(@0);
	}];
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 250);
}

- (CGFloat)backgroundAlpha {
    return 0.5;
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

@end
