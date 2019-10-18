//
//  HWPanModalPresentationUpdateProtocol.h
//  Pods
//
//  Created by heath wang on 2019/10/17.
//

#import <HWPanModal/HWPanModalPresentable.h>

@protocol HWPanModalPresentationUpdateProtocol <NSObject>

/**
 * force update pan modal State, short/long
 */
- (void)hw_panModalTransitionTo:(PresentationState)state NS_SWIFT_NAME(panModalTransitionTo(state:));

/**
 * When presented ViewController has a UIScrollView,
 * Use This method to update UIScrollView contentOffset
 */
- (void)hw_panModalSetContentOffset:(CGPoint)offset NS_SWIFT_NAME(panModalSetContentOffset(offset:));

/**
 * Note：if we present a NavigationController, and we want to pan screen edge to dismiss.
 * We MUST call this method when we PUSH/POP viewController.
 *
 */
- (void)hw_panModalSetNeedsLayoutUpdate NS_SWIFT_NAME(panModalSetNeedsLayoutUpdate());

@end
