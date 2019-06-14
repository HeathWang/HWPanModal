//
//  HWVisualEffectView.m
//  HWPanModal
//
//  Created by heath wang on 2019/6/14.
//

#import "HWVisualEffectView.h"

NSString * const kHWBlurEffectColorTintKey = @"colorTint";
NSString * const kHWBlurEffectColorTintAlphaKey = @"colorTintAlpha";
NSString * const kHWBlurEffectBlurRadiusKey = @"blurRadius";
NSString * const kHWBlurEffectScaleKey = @"scale";

@interface HWVisualEffectView ()

@property (nonatomic, strong) UIBlurEffect *blurEffect;

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

#pragma mark - private method

- (nullable id)__valueForKey:(NSString *)key {
    return [self.blurEffect valueForKey:key];
}

- (void)__setValue:(id)value forKey:(NSString *)key {
    [self.blurEffect setValue:value forKey:key];
    self.effect = self.blurEffect;
}

#pragma mark - Getter & Setter

- (UIBlurEffect *)blurEffect {
    if (!_blurEffect) {
        _blurEffect = (UIBlurEffect *)[NSClassFromString(@"_UICustomBlurEffect") new];
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
