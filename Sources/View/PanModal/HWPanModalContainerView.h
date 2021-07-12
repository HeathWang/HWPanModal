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
@class HWPanContainerView;

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalContainerView : UIView

@property (nonatomic, readonly) HWDimmedView *backgroundView;
@property (readonly) HWPanContainerView *panContainerView;
@property (nonatomic, readonly) PresentationState currentPresentationState;

- (instancetype)initWithPresentingView:(UIView *)presentingView contentView:(HWPanModalContentView<HWPanModalPresentable> *)contentView;

- (void)show;

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion;

- (void)setNeedsLayoutUpdate;

- (void)updateUserHitBehavior;

- (void)transitionToState:(PresentationState)state animated:(BOOL)animated;

- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
