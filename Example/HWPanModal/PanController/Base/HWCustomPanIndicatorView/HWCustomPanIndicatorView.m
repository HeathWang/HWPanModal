//
//  HWCustomPanIndicatorView.m
//  HWPanModal_Example
//
//  Created by politom on 08/08/2019.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWCustomPanIndicatorView.h"

@implementation HWCustomPanIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor yellowColor];
    }
    
    return self;
}

@end
