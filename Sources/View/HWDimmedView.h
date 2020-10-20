//
//  HWDimmedView.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
@class HWBackgroundConfig;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DimState) {
	DimStateMax,
	DimStateOff,
	DimStatePercent,
};

typedef void(^didTap)(UITapGestureRecognizer *recognizer);

@interface HWDimmedView : UIView

@property (nonatomic, assign) DimState dimState;
@property (nonatomic, assign) CGFloat percent;
@property (nullable, nonatomic, copy) didTap tapBlock;
@property (nullable, nonatomic, strong) UIColor *blurTintColor;

@property (nonatomic, readonly) HWBackgroundConfig *backgroundConfig;

/**
 * init with the max dim alpha & max blur radius.
 */
- (instancetype)initWithDimAlpha:(CGFloat)dimAlpha blurRadius:(CGFloat)blurRadius;

- (instancetype)initWithBackgroundConfig:(HWBackgroundConfig *)backgroundConfig;

- (void)reloadConfig:(HWBackgroundConfig *)backgroundConfig;

@end

NS_ASSUME_NONNULL_END
