//
//  HWPanModalShadow.h
//  Pods
//
//  Created by hb on 2023/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalShadow : NSObject

@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowOpacity;

- (instancetype)initWithColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;

+ (instancetype)panModalShadowNil;


@end

NS_ASSUME_NONNULL_END
