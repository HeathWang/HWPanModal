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
		return PanModalHeightMake(PanModalHeightTypeContent, [self panScrollable].contentSize.height);
	} else {
		return PanModalHeightMake(PanModalHeightTypeMax, 0);
	}
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
	return 0.7;
}

- (CGFloat)backgroundBlurRadius {
	return 0;
}

- (UIEdgeInsets)scrollIndicatorInsets {
	CGFloat top = [self shouldRoundTopCorners] ? [self cornerRadius] : 0;
	return UIEdgeInsetsMake(top, 0, self.bottomLayoutOffset, 0);
}

- (BOOL)anchorModalToLongForm {
	return YES;
}

- (BOOL)allowsExtendedPanScrolling {
	if ([self panScrollable]) {
		[[self panScrollable] layoutIfNeeded];
		return [self panScrollable].contentSize.height > ([self panScrollable].frame.size.height - self.bottomLayoutOffset);
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

- (BOOL)shouldRoundTopCorners {
	return YES;
}

- (CGFloat)cornerRadius {
	return 8;
}

- (BOOL)showDragIndicator {
	return [self shouldRoundTopCorners];
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


@end
