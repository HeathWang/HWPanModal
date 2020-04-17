//
//  HWBackgroundConfig.h
//  Pods
//
//  Created by heath wang on 2020/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HWBackgroundBehavior) {
    HWBackgroundBehaviorDefault, // use background alpha
    HWBackgroundBehaviorSystemVisualEffect, // use system UIVisualEffect object
    HWBackgroundBehaviorCustomBlurEffect, // use custom blur
};

@interface HWBackgroundConfig : NSObject

@property (nonatomic, assign) HWBackgroundBehavior backgroundBehavior;
// ONLY works for backgroundBehavior = HWBackgroundBehaviorDefault
@property (nonatomic, assign) CGFloat backgroundAlpha; // default is 0.7
// ONLY works for backgroundBehavior = HWBackgroundBehaviorSystemVisualEffect
@property (nonatomic, strong) UIVisualEffect *visualEffect; // default is UIBlurEffectStyleLight

// ONLY works for backgroundBehavior = HWBackgroundBehaviorCustomBlurEffect
@property (nonatomic, strong) UIColor *blurTintColor; // default is white color
@property (nonatomic, assign) CGFloat backgroundBlurRadius; // default is 10

- (instancetype)initWithBehavior:(HWBackgroundBehavior)backgroundBehavior;

+ (instancetype)configWithBehavior:(HWBackgroundBehavior)backgroundBehavior;


@end

NS_ASSUME_NONNULL_END
