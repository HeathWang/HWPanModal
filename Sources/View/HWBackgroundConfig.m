//
//  HWBackgroundConfig.m
//  Pods
//
//  Created by heath wang on 2020/4/17.
//

#import "HWBackgroundConfig.h"

@implementation HWBackgroundConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundBehavior = HWBackgroundBehaviorDefault;
    }

    return self;
}

- (instancetype)initWithBehavior:(HWBackgroundBehavior)backgroundBehavior {
    self = [super init];
    if (self) {
        self.backgroundBehavior = backgroundBehavior;
    }

    return self;
}

+ (instancetype)configWithBehavior:(HWBackgroundBehavior)backgroundBehavior {
    return [[self alloc] initWithBehavior:backgroundBehavior];
}

#pragma mark - Setter

- (void)setBackgroundBehavior:(HWBackgroundBehavior)backgroundBehavior {
    _backgroundBehavior = backgroundBehavior;

    switch (backgroundBehavior) {
        case HWBackgroundBehaviorSystemVisualEffect: {
            self.visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
            break;
        case HWBackgroundBehaviorCustomBlurEffect: {
            self.backgroundBlurRadius = 10;
            self.blurTintColor = [UIColor whiteColor];
        }
            break;
        default: {
            self.backgroundAlpha = 0.7;
        }
            break;
    }
}


@end
