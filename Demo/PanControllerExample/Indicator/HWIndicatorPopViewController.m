//
//  HWIndicatorPopViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWIndicatorPopViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "HWTextIndicatorView.h"
#import "HWImmobileIndicatorView.h"

@interface HWIndicatorPopViewController () <HWPanModalPresentable>

@end

@implementation HWIndicatorPopViewController

- (instancetype)initWithIndicatorStyle:(HWIndicatorStyle)indicatorStyle {
    self = [super init];
    if (self) {
        _indicatorStyle = indicatorStyle;
    }

    return self;
}

+ (instancetype)controllerWithIndicatorStyle:(HWIndicatorStyle)indicatorStyle {
    return [[self alloc] initWithIndicatorStyle:indicatorStyle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.800 alpha:1.00];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 44);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

- (nullable UIView <HWPanModalIndicatorProtocol> *)customIndicatorView {
    switch (self.indicatorStyle) {
        case HWIndicatorStyleChangeColor: {
            HWPanIndicatorView *indicatorView = [HWPanIndicatorView new];
            indicatorView.indicatorColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.800 alpha:1.00];
            return indicatorView;
        }
        case HWIndicatorStyleText: {
            HWTextIndicatorView *textIndicatorView = [HWTextIndicatorView new];
            return textIndicatorView;
        }
        case HWIndicatorStyleImmobile: {
            HWImmobileIndicatorView *immobileIndicatorView = [HWImmobileIndicatorView new];
            return immobileIndicatorView;
        }
    }
    return nil;
}


@end
