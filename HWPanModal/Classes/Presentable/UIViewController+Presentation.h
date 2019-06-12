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
 * The presented Controller can use the category to update UIPresentationController container.
 */
@interface UIViewController (Presentation)

/**
 * force update pan modal State, short/long
 */
- (void)hw_panModalTransitionTo:(PresentationState)state;

/**
 * When presented ViewController has a UIScrollView,
 * Use This method to update UIScrollView contentOffset
 */
- (void)hw_panModalSetContentOffset:(CGPoint)offset;

/**
 * Note：if we present a NavigationController, and we want to pan screen edge to dismiss.
 * We MUST call this method when we PUSH/POP viewController.
 *
 */
- (void)hw_panModalSetNeedsLayoutUpdate;

@end

NS_ASSUME_NONNULL_END
