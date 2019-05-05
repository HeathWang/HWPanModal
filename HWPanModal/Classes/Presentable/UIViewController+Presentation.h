//
//  UIViewController+Presentation.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import "HWPanModalPresentable.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Presentation)

- (void)hw_panModalTransitionTo:(PresentationState)state;

- (void)hw_panModalSetContentOffset:(CGPoint)offset;

- (void)hw_panModalSetNeedsLayoutUpdate;

- (void)hw_panModalAnimate:(AnimationBlockType)block completion:(AnimationCompletionType)completion;

@end

NS_ASSUME_NONNULL_END
