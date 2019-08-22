//
//  HWColorCollectionViewCell.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/6/14.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWColorCollectionViewCell.h"

@interface HWColorCollectionViewCell ()

@end

@implementation HWColorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = self.bgColor;
    }

    return self;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.contentView.backgroundColor = _bgColor;
}


@end
