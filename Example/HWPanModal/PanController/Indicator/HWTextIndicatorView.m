//
//  HWTextIndicatorView.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWTextIndicatorView.h"

@interface HWTextIndicatorView ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation HWTextIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stateLabel = [UILabel new];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textColor = [UIColor darkTextColor];

        [self addSubview:_stateLabel];
    }

    return self;
}


- (void)didChangeToState:(HWIndicatorState)state {
    switch (state) {
        case HWIndicatorStateNormal: {
            self.stateLabel.text = @"Please pull down to dismiss";
            self.stateLabel.textColor = [UIColor whiteColor];
        }
            break;
        case HWIndicatorStatePullDown: {
            self.stateLabel.text = @"Keep pull down to dismiss";
            self.stateLabel.textColor = [UIColor colorWithRed:1.000 green:0.200 blue:0.000 alpha:1.00];
        }
            break;
    }
}

- (CGSize)indicatorSize {
    return CGSizeMake(200, 18);
}

- (void)setupSubviews {
    self.stateLabel.frame = self.bounds;
}


@end
