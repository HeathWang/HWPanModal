//
//  HWShoppingCartViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/28.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWShoppingCartViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/Masonry.h>

@interface HWShoppingCartViewController () <HWPanModalPresentable>

@property (nonatomic, strong) UIImageView *IMGView;

@end

@implementation HWShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.IMGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shopping"]];
    [self.view addSubview:self.IMGView];
    [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)didTapToDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HWPanModalPresentable


- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 512.5);
}

- (BOOL)shouldAnimatePresentingVC {
    return YES;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (NSTimeInterval)transitionDuration {
    return 1.0;
}

- (CGFloat)springDamping {
    return 1;
}

@end
