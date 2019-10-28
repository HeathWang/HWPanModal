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

- (UIViewAnimationOptions)transitionAnimationOptions {
	return UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
}

- (CGFloat)backgroundAlpha {
    // set the background alpha = 0 when allows touch events passing through
    if ([self allowsTouchEventsPassingThroughTransitionView]) {
        return 0;
    }
	return 0.7;
}

- (CGFloat)backgroundBlurRadius {
	return 0;
}

- (nonnull UIColor *)backgroundBlurColor {
    return [UIColor whiteColor];
}

- (UIEdgeInsets)scrollIndicatorInsets {
	CGFloat top = [self shouldRoundTopCorners] ? [self cornerRadius] : 0;
	return UIEdgeInsetsMake(top, 0, self.bottomLayoutOffset, 0);
}

- (BOOL)showsScrollableVerticalScrollIndicator {
	return YES;
}

- (BOOL)anchorModalToLongForm {
	return YES;
}

- (BOOL)allowsExtendedPanScrolling {
	if ([self panScrollable]) {
        UIScrollView *scrollable = [self panScrollable];
		[scrollable layoutIfNeeded];
		return scrollable.contentSize.height > (scrollable.frame.size.height - self.bottomLayoutOffset);
	} else {
		return NO;
	}
}

- (BOOL)allowsDragToDismiss {
	return YES;
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

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
	return PresentingViewControllerAnimationStyleNone;
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

- (HWPanModalShadow)contentShadow {
    return PanModalShadowMake(nil, 0, CGSizeZero, 0);
}

- (BOOL)showDragIndicator {
    if ([self allowsTouchEventsPassingThroughTransitionView]) {
        return NO;
    }
	return [self shouldRoundTopCorners];
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

- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	return NO;
}

- (BOOL)shouldTransitionToState:(PresentationState)state {
	return YES;
}

- (void)willTransitionToState:(PresentationState)state {

}

- (void)panModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent {

}

- (void)panModalWillDismiss {
    
}

- (void)panModalDidDismissed {
    
}

@end

