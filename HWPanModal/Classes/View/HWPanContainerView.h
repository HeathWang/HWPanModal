//
//  HWPanContainerView.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWPanContainerView : UIView

- (instancetype)initWithPresentedView:(UIView *)presentedView frame:(CGRect)frame;
@end

@interface UIView (PanContainer)

@property (nullable, nonatomic, strong, readonly) HWPanContainerView *panContainerView;

@end

NS_ASSUME_NONNULL_END
