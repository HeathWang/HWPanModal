//
//  UIColor+HW.m
//  HWPanModalDemo
//
//  Created by heath wang on 2020/1/15.
//  Copyright © 2020 wangcongling. All rights reserved.
//

#import "UIColor+HW.h"

@implementation UIColor (HW)

+ (instancetype)hw_randomColor {
    UIColor *color = [UIColor colorWithRed:(arc4random() % 255 + 1) / 255.0f green:(arc4random() % 255 + 1) / 255.0f blue:(arc4random() % 255 + 1) / 255.0f alpha:1];
    return color;
}

@end
