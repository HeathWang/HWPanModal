//
//  HWImmobileIndicatorView.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWImmobileIndicatorView.h"

@interface HWImmobileIndicatorView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation HWImmobileIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.layer.cornerRadius = 4;

        [self addSubview:_lineView];
    }

    return self;
}


- (void)didChangeToState:(HWIndicatorState)state {
    // do nothing
}

- (CGSize)indicatorSize {
    return CGSizeMake(45, 8);
}

- (void)setupSubviews {
    self.lineView.frame = CGRectMake(0, 0, [self indicatorSize].width, [self indicatorSize].height);
}


@end
