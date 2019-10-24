//
//  HWPanModalContainerView.h
//  Pods
//
//  Created by heath wang on 2019/10/17.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>

@class HWPanModalContentView;

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalContainerView : UIView

- (instancetype)initWithPresentingView:(UIView *)presentingView contentView:(HWPanModalContentView<HWPanModalPresentable> *)contentView;

- (void)show;

- (void)setNeedsLayoutUpdate;

- (void)transitionToState:(PresentationState)state;

- (void)setScrollableContentOffset:(CGPoint)offset;


@end

NS_ASSUME_NONNULL_END
