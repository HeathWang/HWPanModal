//
//  UIViewController+Presentation.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 被presented的Controller可以通过该类对UIPresentationController 容器进行update
 */
@interface UIViewController (Presentation)

- (void)hw_panModalTransitionTo:(PresentationState)state;

- (void)hw_panModalSetContentOffset:(CGPoint)offset;

/**
 * Note：if we present a NavigationController, and we want to pan screen edge to dismiss.
 * We MUST call this method when we PUSH/POP viewController.
 *
 */
- (void)hw_panModalSetNeedsLayoutUpdate;

@end

NS_ASSUME_NONNULL_END
