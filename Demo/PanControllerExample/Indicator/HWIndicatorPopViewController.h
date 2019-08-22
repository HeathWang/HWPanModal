//
//  HWIndicatorPopViewController.h
//  HWPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HWIndicatorStyle) {
    HWIndicatorStyleChangeColor,
    HWIndicatorStyleText,
    HWIndicatorStyleImmobile,
};

NS_ASSUME_NONNULL_BEGIN

@interface HWIndicatorPopViewController : UIViewController

@property (nonatomic, assign) HWIndicatorStyle indicatorStyle;

- (instancetype)initWithIndicatorStyle:(HWIndicatorStyle)indicatorStyle;

+ (instancetype)controllerWithIndicatorStyle:(HWIndicatorStyle)indicatorStyle;


@end

NS_ASSUME_NONNULL_END
