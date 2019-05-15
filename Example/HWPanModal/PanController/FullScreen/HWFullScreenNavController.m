//
//  HWFullScreenNavController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/13.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWFullScreenNavController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/View+MASAdditions.h>

@interface HWFullScreenViewController : UIViewController

@end

@interface HWFullScreenNavController () <HWPanModalPresentable>

@end

@implementation HWFullScreenNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pushViewController:[HWFullScreenViewController new] animated:NO];
}

#pragma mark - HWPanModalPresentable

- (CGFloat)topOffset {
    return 0;
}

- (NSTimeInterval)transitionDuration {
    return 0.5;
}

- (BOOL)shouldRoundTopCorners {
    return NO;
}

- (BOOL)showDragIndicator {
    return NO;
}

@end


@implementation HWFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"Full Screen";

    UILabel *label = [UILabel new];
    label.text = @"Drag to Dismiss!";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];
}


@end
