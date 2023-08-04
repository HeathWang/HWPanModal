//
//  HWPanModalShadow.m
//  Pods
//
//  Created by hb on 2023/8/3.
//

#import "HWPanModalShadow.h"

@implementation HWPanModalShadow

- (instancetype)initWithColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity {
    self = [super init];
    if (self) {
        _shadowColor = shadowColor;
        _shadowRadius = shadowRadius;
        _shadowOffset = shadowOffset;
        _shadowOpacity = shadowOpacity;
    }
    
    return self;
}

+ (instancetype)panModalShadowNil {
    return [[HWPanModalShadow alloc] initWithColor:[UIColor clearColor] shadowRadius:0 shadowOffset:CGSizeZero shadowOpacity:0];
}

@end
