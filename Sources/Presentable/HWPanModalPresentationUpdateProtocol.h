//
//  HWPanModalPresentationUpdateProtocol.h
//  Pods
//
//  Created by heath wang on 2019/10/17.
//

#import <HWPanModal/HWPanModalPresentable.h>
@class HWDimmedView;

@protocol HWPanModalPresentationUpdateProtocol <NSObject>
/// background view, you can call `reloadConfig:`  to update the UI.
@property (nonatomic, readonly) HWDimmedView *hw_dimmedView;
/// the root container which your custom VC's view to be added.
@property (nonatomic, readonly) UIView *hw_rootContainerView;
/// which view that your presented viewController's view has been added.
@property (nonatomic, readonly) UIView *hw_contentView;
/// current presentation State
@property (nonatomic, readonly) PresentationState hw_presentationState;
/**
 * force update pan modal State, short/long
 */
- (void)hw_panModalTransitionTo:(PresentationState)state NS_SWIFT_NAME(panModalTransitionTo(state:));

/**
 * force update pan modal State, short/long
 * @param state transition state
 * @param animated whether animate when set state
 */
- (void)hw_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated NS_SWIFT_NAME(panModalTransitionTo(state:animated:));

/**
 * When presented ViewController has a UIScrollView, Use This method to update UIScrollView contentOffset
 * Default it has animation
 */
- (void)hw_panModalSetContentOffset:(CGPoint)offset NS_SWIFT_NAME(panModalSetContentOffset(offset:));

/**
 * When presented ViewController has a UIScrollView, Use This method to update UIScrollView contentOffset
 * @param offset scrollView offset value
 * @param animated whether animate
 */
- (void)hw_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated NS_SWIFT_NAME(panModalSetContentOffset(offset:animated:));

/**
 * Note：if we present a NavigationController, and we want to pan screen edge to dismiss.
 * We MUST call this method when we PUSH/POP viewController.
 *
 */
- (void)hw_panModalSetNeedsLayoutUpdate NS_SWIFT_NAME(panModalSetNeedsLayoutUpdate());

/**
 * 更新用户行为，比如事件穿透
 */
- (void)hw_panModalUpdateUserHitBehavior NS_SWIFT_NAME(panModalUpdateUserHitBehavior());

@end
