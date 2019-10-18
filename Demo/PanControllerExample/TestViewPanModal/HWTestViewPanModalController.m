//
//  HWTestViewPanModalController.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/10/18.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

#import "HWTestViewPanModalController.h"
#import <Masonry/Masonry.h>
#import "HWSimplePanModalView.h"

@interface HWTestViewPanModalController ()

@property (nonatomic, strong) UIButton *presentButton;

@end

@implementation HWTestViewPanModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.presentButton];

    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo(CGSizeMake(88, 66));
    }];
}

#pragma mark - touch action

- (void)didTapToPresent {
    HWSimplePanModalView *simplePanModalView = [HWSimplePanModalView new];
    [simplePanModalView presentInView:nil];
}

#pragma mark - Getter

- (UIButton *)presentButton {
    if (!_presentButton) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentButton setTitleColor:[UIColor colorWithRed:0.000 green:0.600 blue:0.800 alpha:1.00] forState:UIControlStateNormal];
        [_presentButton setTitle:@"Present" forState:UIControlStateNormal];
        _presentButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_presentButton addTarget:self action:@selector(didTapToPresent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}


@end
