//
//  UIViewController+PanModalDefault.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "UIViewController+PanModalDefault.h"
#import "UIViewController+LayoutHelper.h"

@implementation UIViewController (PanModalDefault)

- (UIScrollView *)panScrollable {
	return nil;
}

- (CGFloat)topOffset {
	return self.topLayoutOffset + 21.f;
}

- (PanModalHeight)shortFormHeight {
	return [self longFormHeight];
}

- (PanModalHeight)mediumFormHeight {
    return [self longFormHeight];
}

- (PanModalHeight)longFormHeight {
	if ([self panScrollable]) {
		[[self panScrollable] layoutIfNeeded];
		return PanModalHeightMake(PanModalHeightTypeContent, MAX([self panScrollable].contentSize.height, [self panScrollable].bounds.size.height));
	} else {
		return PanModalHeightMake(PanModalHeightTypeMax, 0);
	}
}

- (PresentationState)originPresentationState {
	return PresentationStateShort;
}

- (CGFloat)springDamping {
	return 0.8;
}

- (NSTimeInterval)transitionDuration {
	return 0.5;
}

- (NSTimeInterval)dismissalDuration {
	return [self transitionDuration];
}

- (UIViewAnimationOptions)transitionAnimationOptions {
	return UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
}

- (CGFloat)backgroundAlpha {
	return 0.7;
}

- (CGFloat)backgroundBlurRadius {
	return 0;
}

- (nonnull UIColor *)backgroundBlurColor {
    return [UIColor whiteColor];
}

- (HWBackgroundConfig *)backgroundConfig {
    return [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
}

- (UIEdgeInsets)scrollIndicatorInsets {
	CGFloat top = [self shouldRoundTopCorners] ? [self cornerRadius] : 0;
	return UIEdgeInsetsMake(top, 0, self.bottomLayoutOffset, 0);
}

- (BOOL)showsScrollableVerticalScrollIndicator {
	return YES;
}

- (BOOL)shouldAutoSetPanScrollContentInset {
    return YES;
}

- (BOOL)anchorModalToLongForm {
	return YES;
}

- (BOOL)allowsExtendedPanScrolling {
	if ([self panScrollable]) {
        UIScrollView *scrollable = [self panScrollable];

        /*
         [TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window.
         */
        if (!scrollable.superview || !scrollable.window) return NO;

		[scrollable layoutIfNeeded];
		return scrollable.contentSize.height > (scrollable.frame.size.height - self.bottomLayoutOffset);
	}

    return NO;
}

- (BOOL)allowsDragToDismiss {
	return YES;
}

- (CGFloat)minVerticalVelocityToTriggerDismiss {
    return 300;
}

- (BOOL)allowsTapBackgroundToDismiss {
	return YES;
}

- (BOOL)allowScreenEdgeInteractive {
	return NO;
}

- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction {
	return 0;
}

- (CGFloat)minHorizontalVelocityToTriggerScreenEdgeDismiss {
    return 500;
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
	return PresentingViewControllerAnimationStyleNone;
}

- (BOOL)shouldEnableAppearanceTransition {
    return YES;
}

- (BOOL)shouldAnimatePresentingVC {
    return NO;
}

- (id <HWPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation {
	return nil;
}

- (BOOL)isPanScrollEnabled {
	return YES;
}

- (BOOL)isUserInteractionEnabled {
	return YES;
}

- (BOOL)allowsPullDownWhenShortState {
    return YES;
}

- (BOOL)isHapticFeedbackEnabled {
	return YES;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView {
	return NO;
}

- (BOOL)shouldRoundTopCorners {
	return YES;
}

- (CGFloat)cornerRadius {
	return 8;
}

- (HWPanModalShadow *)contentShadow {
    return [HWPanModalShadow panModalShadowNil];
}

- (BOOL)showDragIndicator {
    if ([self allowsTouchEventsPassingThroughTransitionView]) {
        return NO;
    }
	return YES;
}

- (nullable UIView <HWPanModalIndicatorProtocol> *)customIndicatorView {
	return nil;
}

- (BOOL)isAutoHandleKeyboardEnabled {
	return YES;
}

- (CGFloat)keyboardOffsetFromInputView {
    return 5;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	return YES;
}

- (void)willRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {

}

- (void)didRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    
}

- (void)didEndRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer {
	
}

- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	return NO;
}

- (BOOL)shouldTransitionToState:(PresentationState)state {
	return YES;
}

- (void)willTransitionToState:(PresentationState)state {
}

- (void)didChangeTransitionToState:(PresentationState)state {
}

- (void)panModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent {

}

- (void)panModalWillDismiss {
    
}

- (void)panModalDidDismissed {
    
}

- (void)panModalTransitionWillBegin {
    
}

- (void)panModalTransitionDidFinish {
    
}

- (void)presentedViewDidMoveToSuperView {
    
}

@end

