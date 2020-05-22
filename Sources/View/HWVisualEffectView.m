//
//  HWVisualEffectView.m
//  HWPanModal
//
//  Created by heath wang on 2019/6/14.
//

#import "HWVisualEffectView.h"

NSString * const kInternalCustomBlurEffect = @"_UICustomBlurEffect";
NSString * const kHWBlurEffectColorTintKey = @"colorTint";
NSString * const kHWBlurEffectColorTintAlphaKey = @"colorTintAlpha";
NSString * const kHWBlurEffectBlurRadiusKey = @"blurRadius";
NSString * const kHWBlurEffectScaleKey = @"scale";

@interface HWVisualEffectView ()

@property (nonatomic, strong) UIVisualEffect *blurEffect;

@end

@implementation HWVisualEffectView

@synthesize colorTint = _colorTint;
@synthesize colorTintAlpha = _colorTintAlpha;
@synthesize blurRadius = _blurRadius;
@synthesize scale = _scale;

#pragma mark - init

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        self.scale = 1;
    }
    return self;
}

#pragma mark - public method

- (void)updateBlurEffect:(UIVisualEffect *)effect {
    self.blurEffect = effect;
    self.effect = self.blurEffect;
}

#pragma mark - private method

- (nullable id)__valueForKey:(NSString *)key {
    if (![NSStringFromClass(self.blurEffect.class) isEqualToString:kInternalCustomBlurEffect]) {
        return @(0);
    }
    return [self.blurEffect valueForKey:key];
}

- (void)__setValue:(id)value forKey:(NSString *)key {
    if (![NSStringFromClass(self.blurEffect.class) isEqualToString:kInternalCustomBlurEffect]) {
        self.effect = self.blurEffect;
        return;
    }
    [self.blurEffect setValue:value forKey:key];
    self.effect = self.blurEffect;
}

#pragma mark - Getter & Setter

- (UIVisualEffect *)blurEffect {
    if (!_blurEffect) {
        if (NSClassFromString(kInternalCustomBlurEffect)) {
            _blurEffect = (UIBlurEffect *)[NSClassFromString(@"_UICustomBlurEffect") new];
        } else {
            _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
    }
    
    return _blurEffect;
}

- (UIColor *)colorTint {
    return [self __valueForKey:kHWBlurEffectColorTintKey];
}

- (void)setColorTint:(UIColor *)colorTint {
    [self __setValue:colorTint forKey:kHWBlurEffectColorTintKey];
}

- (CGFloat)colorTintAlpha {
    return ((NSNumber *)[self __valueForKey:kHWBlurEffectColorTintAlphaKey]).floatValue;
}

- (void)setColorTintAlpha:(CGFloat)colorTintAlpha {
    [self __setValue:@(colorTintAlpha) forKey:kHWBlurEffectColorTintAlphaKey];
}

- (CGFloat)blurRadius {
    return ((NSNumber *)[self __valueForKey:kHWBlurEffectBlurRadiusKey]).floatValue;
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    [self __setValue:@(blurRadius) forKey:kHWBlurEffectBlurRadiusKey];
}

- (CGFloat)scale {
    return ((NSNumber *)[self __valueForKey:kHWBlurEffectScaleKey]).floatValue;
}

- (void)setScale:(CGFloat)scale {
     [self __setValue:@(scale) forKey:kHWBlurEffectScaleKey];
}


@end
