//
//  HWPanModalPresentationController.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>

NS_ASSUME_NONNULL_BEGIN


@interface HWPanModalPresentationController : UIPresentationController

- (void)setNeedsLayoutUpdate;

- (void)transitionToState:(PresentationState)state;

- (void)setScrollableContentOffset:(CGPoint)offset;

@end

NS_ASSUME_NONNULL_END
