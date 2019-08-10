//
//  HWPanIndicatorView.h
//  HWPanModal
//
//  Created by heath wang on 2019/5/16.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalIndicatorProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWPanIndicatorView : UIView <HWPanModalIndicatorProtocol>

@property (nonnull, nonatomic, strong) UIColor *indicatorColor;

@end

NS_ASSUME_NONNULL_END
