//
//  HWShoppingCartViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/28.
//  Copyright © 2019 heath wang. All rights reserved.
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

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - HWPanModalPresentable


- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 512.5);
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStyleShoppingCart;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (NSTimeInterval)transitionDuration {
    return 0.8;
}

- (CGFloat)springDamping {
    return 0.9;
}

@end
