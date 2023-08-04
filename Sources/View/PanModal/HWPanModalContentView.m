//
//  HWPanModalContentView.m
//  Pods
//
//  Created by heath wang on 2019/10/17.
//

#import "HWPanModalContentView.h"
#import "HWPanModalContainerView.h"

@interface HWPanModalContentView ()

@property (nonatomic, weak) HWPanModalContainerView *containerView;

@end

@implementation HWPanModalContentView

#pragma mark - public method

- (void)presentInView:(UIView *)view {
    if (!view) {
        view = [self findKeyWindow];
    }
    HWPanModalContainerView *containerView = [[HWPanModalContainerView alloc] initWithPresentingView:view contentView:self];
    [containerView show];
}

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.containerView dismissAnimated:flag completion:completion];
}

#pragma mark - HWPanModalPresentationUpdateProtocol

- (void)hw_panModalTransitionTo:(PresentationState)state {
    [self.containerView transitionToState:state animated:YES];
}

- (void)hw_panModalSetContentOffset:(CGPoint)offset {
    [self.containerView setScrollableContentOffset:offset animated:YES];
}

- (void)hw_panModalSetNeedsLayoutUpdate {
    [self.containerView setNeedsLayoutUpdate];
}

- (void)hw_panModalUpdateUserHitBehavior {
    [self.containerView updateUserHitBehavior];
}

- (void)hw_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated {
    [self.containerView transitionToState:state animated:animated];
}

- (void)hw_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated {
    [self.containerView setScrollableContentOffset:offset animated:animated];
}

- (void)hw_dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissAnimated:animated completion:completion];
}

- (HWDimmedView *)hw_dimmedView {
    return self.containerView.backgroundView;
}

- (UIView *)hw_rootContainerView {
    return self.containerView;
}

- (UIView *)hw_contentView {
    return (UIView *)self.containerView.panContainerView;
}

- (PresentationState)hw_presentationState {
    return self.containerView.currentPresentationState;
}

#pragma mark - HWPanModalPresentable

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
        [scrollable layoutIfNeeded];
        return scrollable.contentSize.height > (scrollable.frame.size.height - self.bottomLayoutOffset);
    } else {
        return NO;
    }
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

- (BOOL)allowsPullDownWhenShortState {
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

- (HWPanModalShadow *)contentShadow {
    return [HWPanModalShadow panModalShadowNil];
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

- (BOOL)shouldEnableAppearanceTransition {
    return YES;
}

#pragma mark - HWPanModalPresentableLayoutProtocol

- (CGFloat)topLayoutOffset {
    return 0;
}

- (CGFloat)bottomLayoutOffset {
    return 0;
}

- (CGFloat)shortFormYPos {
    CGFloat shortFormYPos = [self topMarginFromPanModalHeight:[self shortFormHeight]] + [self topOffset];
    return MAX(shortFormYPos, self.longFormYPos);
}

- (CGFloat)mediumFormYPos {
    CGFloat mediumFormYPos = [self topMarginFromPanModalHeight:[self mediumFormHeight]] + [self topOffset];
    return MAX(mediumFormYPos, self.longFormYPos);
}

- (CGFloat)longFormYPos {
    CGFloat longFrom = MAX([self topMarginFromPanModalHeight:[self longFormHeight]], [self topMarginFromPanModalHeight:PanModalHeightMake(PanModalHeightTypeMax, 0)]) + [self topOffset];
    return longFrom;
}

- (CGFloat)bottomYPos {
    if (self.containerView) {
        return self.containerView.bounds.size.height - [self topOffset];
    }
    return self.bounds.size.height;
}

- (CGFloat)topMarginFromPanModalHeight:(PanModalHeight)panModalHeight {
    switch (panModalHeight.heightType) {
        case PanModalHeightTypeMax:
            return 0.0f;
        case PanModalHeightTypeMaxTopInset:
            return panModalHeight.height;
        case PanModalHeightTypeContent:
            return self.bottomYPos - (panModalHeight.height + self.bottomLayoutOffset);
        case PanModalHeightTypeContentIgnoringSafeArea:
            return self.bottomYPos - panModalHeight.height;
        case PanModalHeightTypeIntrinsic: {
            [self layoutIfNeeded];

            CGSize targetSize = CGSizeMake(self.containerView ? self.containerView.bounds.size.width : [UIScreen mainScreen].bounds.size.width, UILayoutFittingCompressedSize.height);
            CGFloat intrinsicHeight = [self systemLayoutSizeFittingSize:targetSize].height;
            return self.bottomYPos - (intrinsicHeight + self.bottomLayoutOffset);
        }
        default:
            return 0;
    }
}

#pragma mark - Getter

- (HWPanModalContainerView *)containerView {
    // we assume the container view will not change after we got it.
    if (!_containerView) {
        UIView *fatherView = self.superview;
        while (fatherView) {
            if ([fatherView isKindOfClass:HWPanModalContainerView.class]) {
                _containerView = (HWPanModalContainerView *) fatherView;
                break;
            }
            fatherView = fatherView.superview;
        }
    }

    return _containerView;
}

- (UIView *)findKeyWindow {
    
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *tmpWindow in windowScene.windows) {
                    if ([tmpWindow isKeyWindow]) {
                        return tmpWindow;
                    }
                }
            }
        }
        
    } else {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if ([window isKeyWindow]) {
                return window;
            }
        }
    }
    return nil;
}

@end
