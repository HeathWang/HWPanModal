//
//  HWPanModalPresentationController.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>
@class HWDimmedView;

NS_ASSUME_NONNULL_BEGIN


@interface HWPanModalPresentationController : UIPresentationController

@property (nonatomic, readonly) HWDimmedView *backgroundView;

- (void)setNeedsLayoutUpdate;

- (void)transitionToState:(PresentationState)state animated:(BOOL)animated;

- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
