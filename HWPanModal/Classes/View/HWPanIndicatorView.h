//
//  HWPanIndicatorView.h
//  HWPanModal
//
//  Created by heath wang on 2019/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PanIndicatorViewStyle) {
    PanIndicatorViewStyleLine,
    PanIndicatorViewStyleArrow,
};

@interface HWPanIndicatorView : UIView

@property (nonatomic, assign) PanIndicatorViewStyle style;
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
