//
//  UIDevice+HW.h
//  HWPanModalDemo
//
//  Created by heath wang on 2019/12/16.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (HW)

+ (BOOL)isPhoneX;

+ (CGFloat)statusBarHeight;

+ (CGFloat)statusBarAndNaviBarHeight;

+ (CGFloat)tabBarHeight;

+ (CGFloat)safeAreaInsetsBottomHeight;

+ (CGFloat)safeAreaInsetsTopHeight;
@end

NS_ASSUME_NONNULL_END
