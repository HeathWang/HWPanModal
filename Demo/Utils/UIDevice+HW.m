//
//  UIDevice+HW.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/12/16.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "UIDevice+HW.h"


@implementation UIDevice (HW)

+ (BOOL)isPhoneX {
    if ([UIScreen mainScreen].bounds.size.height >= 812) {
        return YES;
    }
    return NO;
}

+ (CGFloat)statusBarHeight {
    return  [UIDevice safeAreaInsetsTopHeight] > 0 ? [UIDevice safeAreaInsetsTopHeight] : 20;
}

+ (CGFloat)statusBarAndNaviBarHeight {
    return 44.f + [UIDevice statusBarHeight];
}

+ (CGFloat)tabBarHeight {
    return 49 + [UIDevice safeAreaInsetsBottomHeight];
}

+ (CGFloat)safeAreaInsetsBottomHeight {
    CGFloat gap = 0.f;
    if (@available(iOS 11, *)) {
        if ([UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame.size.height > 0) {
            gap = ([UIApplication sharedApplication].keyWindow.frame.size.height - [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame.origin.y - [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame.size.height);
        } else {
            gap = 0;
        }
    } else {
        gap = 0;
    }
    return gap;
}

+ (CGFloat)safeAreaInsetsTopHeight {
    CGFloat gap = 0.f;
    if (@available(iOS 11, *)) {
        gap = [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame.origin.y;
    } else {
        gap = 0;
    }
    return gap;
}

@end
