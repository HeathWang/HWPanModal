//
//  HWPanModalContainerView.h
//  Pods
//
//  Created by heath wang on 2019/10/17.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>

@class HWPanModalContentView;
@class HWDimmedView;

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalContainerView : UIView

@property (nonatomic, readonly) HWDimmedView *backgroundView;

- (instancetype)initWithPresentingView:(UIView *)presentingView contentView:(HWPanModalContentView<HWPanModalPresentable> *)contentView;

- (void)show;

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion;

- (void)setNeedsLayoutUpdate;

- (void)transitionToState:(PresentationState)state animated:(BOOL)animated;

- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
