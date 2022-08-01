//
//  HWPanModalPresentableHandler.m
//  HWPanModal
//
//  Created by heath wang on 2019/10/15.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

#import "HWPanModalPresentableHandler.h"
#import "UIScrollView+Helper.h"
#import "UIViewController+LayoutHelper.h"
#import "UIView+HW_Frame.h"
#import "KeyValueObserver.h"
#import "HWPanModalContentView.h"

static NSString *const kScrollViewKVOContentOffsetKey = @"contentOffset";

@interface HWPanModalPresentableHandler ()

@property (nonatomic, assign) CGFloat shortFormYPosition;

@property (nonatomic, assign) CGFloat mediumFormYPosition;

@property (nonatomic, assign) CGFloat longFormYPosition;

@property (nonatomic, assign) BOOL extendsPanScrolling;

@property (nonatomic, assign) BOOL anchorModalToLongForm;

@property (nonatomic, assign) CGFloat anchoredYPosition;

@property (nonatomic, strong) id<HWPanModalPresentable, HWPanModalPanGestureDelegate> presentable;

// keyboard handle
@property (nonatomic, copy) NSDictionary *keyboardInfo;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *screenEdgeGestureRecognizer;

// kvo
@property (nonatomic, strong) id observerToken;
@property (nonatomic, assign) CGFloat scrollViewYOffset;

@end

@implementation HWPanModalPresentableHandler

- (instancetype)initWithPresentable:(id <HWPanModalPresentable>)presentable {
    self = [super init];
    if (self) {
        _presentable = presentable;
        _extendsPanScrolling = YES;
        _anchorModalToLongForm = YES;
        [self addKeyboardObserver];
    }

    return self;
}

+ (instancetype)handlerWithPresentable:(id <HWPanModalPresentable>)presentable {
    return [[self alloc] initWithPresentable:presentable];
}

#pragma mark - Pan Gesture Event Handler

- (void)didPanOnView:(UIPanGestureRecognizer *)panGestureRecognizer {

    if ([self shouldResponseToPanGestureRecognizer:panGestureRecognizer] && !self.keyboardInfo) {

        switch (panGestureRecognizer.state) {

            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged: {
                [self handlePanGestureBeginOrChanged:panGestureRecognizer];
            }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed: {
                [self handlePanGestureEnded:panGestureRecognizer];
            }
                break;
            default: break;
        }
    } else {
        [self handlePanGestureDidNotResponse:panGestureRecognizer];
    }
    [self.presentable didRespondToPanModalGestureRecognizer:panGestureRecognizer];
}

- (BOOL)shouldResponseToPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if ([self.presentable shouldRespondToPanModalGestureRecognizer:panGestureRecognizer] ||
            !(panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateCancelled)) {

        return ![self shouldFailPanGestureRecognizer:panGestureRecognizer];
    } else {
        // stop pan gesture working.
        panGestureRecognizer.enabled = NO;
        panGestureRecognizer.enabled = YES;
        return NO;
    }
}

- (BOOL)shouldFailPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {

    if ([self shouldPrioritizePanGestureRecognizer:panGestureRecognizer]) {
        // high priority than scroll view gesture, disable scrollView gesture.
        [self.presentable panScrollable].panGestureRecognizer.enabled = NO;
        [self.presentable panScrollable].panGestureRecognizer.enabled = YES;
        return NO;
    }
    
    if ([self shouldHandleShortStatePullDownWithRecognizer:panGestureRecognizer]) {
//        panGestureRecognizer.enabled = NO;
//        panGestureRecognizer.enabled = YES;
        return YES;
    }

    BOOL shouldFail = NO;
    UIScrollView *scrollView = [self.presentable panScrollable];
    if (scrollView) {
        shouldFail = scrollView.contentOffset.y > -MAX(scrollView.contentInset.top, 0);

        // we want scroll the panScrollable, not the presentedView
        if (self.isPresentedViewAnchored && shouldFail) {
            CGPoint location = [panGestureRecognizer locationInView:self.presentedView];
            BOOL flag = CGRectContainsPoint(scrollView.frame, location) || scrollView.isScrolling;
            if (flag) {
                [self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
            }
            return flag;
        } else {
            return NO;
        }

    } else {
        return NO;
    }

}

- (BOOL)shouldHandleShortStatePullDownWithRecognizer:(UIPanGestureRecognizer *)recognizer {
    if ([self.presentable allowsPullDownWhenShortState]) return NO;
    
    CGPoint location = [recognizer translationInView:self.presentedView];
    if ([self.delegate getCurrentPresentationState] == PresentationStateShort && recognizer.state == UIGestureRecognizerStateBegan) {
        return YES;
    }
    
    if ((self.presentedView.frame.origin.y >= self.shortFormYPosition || HW_TWO_FLOAT_IS_EQUAL(self.presentedView.frame.origin.y, self.shortFormYPosition)) && location.y > 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldPrioritizePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    return recognizer.state == UIGestureRecognizerStateBegan && [[self presentable] shouldPrioritizePanModalGestureRecognizer:recognizer];
}

- (void)respondToPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    [self.presentable willRespondToPanModalGestureRecognizer:panGestureRecognizer];

    CGFloat yDisplacement = [panGestureRecognizer translationInView:self.presentedView].y;

    if (self.presentedView.frame.origin.y < self.longFormYPosition) {
        yDisplacement = yDisplacement / 2;
    }

    id <HWPanModalPresentableHandlerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(adjustPresentableYPos:)]) {
        [delegate adjustPresentableYPos:self.presentedView.frame.origin.y + yDisplacement];
    }

    [panGestureRecognizer setTranslation:CGPointZero inView:self.presentedView];
}

- (BOOL)isVelocityWithinSensitivityRange:(CGFloat)velocity {
    return (fabs(velocity) - [self.presentable minVerticalVelocityToTriggerDismiss]) > 0;
}

- (CGFloat)nearestDistance:(CGFloat)position inDistances:(NSArray *)distances {

    if (distances.count <= 0) {
        return position;
    }

    // TODO: need refine this sort code.
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:distances.count];
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:distances.count];

    [distances enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *number = obj;
        NSNumber *absValue = @(fabs(number.floatValue - position));
        [tmpArr addObject:absValue];
        tmpDict[absValue] = number;

    }];

    [tmpArr sortUsingSelector:@selector(compare:)];

    NSNumber *result = tmpDict[tmpArr.firstObject];
    return result.floatValue;
}

- (void)screenEdgeInteractiveAction:(UIPanGestureRecognizer *)gestureRecognizer {
    //
}

#pragma mark - handle did Pan gesture events

- (void)handlePanGestureDidNotResponse:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
            [self cancelInteractiveTransition];
        }
            break;
        default:
            break;
    }
    [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
}

- (void)handlePanGestureBeginOrChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.presentedView];
    [self respondToPanGestureRecognizer:panGestureRecognizer];

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // check if toggle dismiss action
        if ([[self presentable] presentingVCAnimationStyle] > PresentingViewControllerAnimationStyleNone &&
                velocity.y > 0 &&
                (self.presentedView.frame.origin.y > self.shortFormYPosition || HW_TWO_FLOAT_IS_EQUAL(self.presentedView.frame.origin.y, self.shortFormYPosition))) {
            [self dismissPresentable:YES mode:PanModalInteractiveModeDragDown];
        }
    }

    if (HW_TWO_FLOAT_IS_EQUAL(self.presentedView.frame.origin.y, self.anchoredYPosition) && self.extendsPanScrolling) {
        [self.presentable willTransitionToState:PresentationStateLong];
    }

    // update drag indicator
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (velocity.y > 0) {
            [self.dragIndicatorView didChangeToState:HWIndicatorStatePullDown];
        } else if (velocity.y < 0 && self.presentedView.frame.origin.y <= self.anchoredYPosition && !self.extendsPanScrolling) {
            [self.dragIndicatorView didChangeToState:HWIndicatorStateNormal];
        }
    }
}

- (void)handlePanGestureEnded:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.presentedView];
    /**
     * pan recognizer结束
     * 根据velocity(速度)，当velocity.y < 0，说明用户在向上拖拽view；当velocity.y > 0，向下拖拽
     * 根据拖拽的速度，处理不同的情况：
     * 1.超过拖拽速度阈值时并且向下拖拽，dismiss controller
     * 2.向上拖拽永远不会dismiss，回弹至相应的状态
     */

    if ([self isVelocityWithinSensitivityRange:velocity.y]) {
        
        id <HWPanModalPresentableHandlerDelegate> delegate = self.delegate;
        PresentationState currentState = [delegate getCurrentPresentationState];
        
        if (velocity.y < 0) {
            [self handleDragUpState:currentState];
        } else {
            [self handleDragDownState:currentState];
        }
    } else {
        CGFloat position = [self nearestDistance:CGRectGetMinY(self.presentedView.frame) inDistances:@[@([self containerSize].height), @(self.shortFormYPosition), @(self.longFormYPosition), @(self.mediumFormYPosition)]];
        if (HW_TWO_FLOAT_IS_EQUAL(position, self.longFormYPosition)) {
            [self transitionToState:PresentationStateLong];
            [self cancelInteractiveTransition];
        } else if (HW_TWO_FLOAT_IS_EQUAL(position, self.mediumFormYPosition)) {
            [self transitionToState:PresentationStateMedium];
            [self cancelInteractiveTransition];
        } else if (HW_TWO_FLOAT_IS_EQUAL(position, self.shortFormYPosition) || ![self.presentable allowsDragToDismiss]) {
            [self transitionToState:PresentationStateShort];
            [self cancelInteractiveTransition];
        } else {
            if ([self isBeingDismissed]) {
                [self finishInteractiveTransition];
            } else {
                [self dismissPresentable:NO mode:PanModalInteractiveModeNone];
            }
        }
    }
	[self.presentable didEndRespondToPanModalGestureRecognizer:panGestureRecognizer];
}

- (void)handleDragUpState:(PresentationState)state {
    switch (state) {
        case PresentationStateLong:
            [self transitionToState:PresentationStateLong];
            [self cancelInteractiveTransition];
            break;
        case PresentationStateMedium:
            [self transitionToState:PresentationStateLong];
            [self cancelInteractiveTransition];
            break;
        case PresentationStateShort:
            [self transitionToState:PresentationStateMedium];
            [self cancelInteractiveTransition];
            break;
        default:
            break;
    }
}

- (void)handleDragDownState:(PresentationState)state {
    switch (state) {
        case PresentationStateLong:
            [self transitionToState:PresentationStateMedium];
            [self cancelInteractiveTransition];
            break;
        case PresentationStateMedium:
            [self transitionToState:PresentationStateShort];
            [self cancelInteractiveTransition];
            break;
        case PresentationStateShort:
            if (![self.presentable allowsDragToDismiss]) {
                [self transitionToState:PresentationStateShort];
                [self cancelInteractiveTransition];
            } else {
                if ([self isBeingDismissed]) {
                    [self finishInteractiveTransition];
                } else {
                    [self dismissPresentable:NO mode:PanModalInteractiveModeNone];
                }
            }
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollView kvo

- (void)observeScrollable {
    UIScrollView *scrollView = [[self presentable] panScrollable];
    if (!scrollView) {
        // force set observerToken to nil, make sure to callback.
        self.observerToken = nil;
        return;
    }
    
    self.scrollViewYOffset = MAX(scrollView.contentOffset.y, -(MAX(scrollView.contentInset.top, 0)));
    self.observerToken = [KeyValueObserver observeObject:scrollView keyPath:kScrollViewKVOContentOffsetKey target:self selector:@selector(didPanOnScrollViewChanged:) options:NSKeyValueObservingOptionOld];
}

/**
 As the user scrolls, track & save the scroll view y offset.
 This helps halt scrolling when we want to hold the scroll view in place.
*/
- (void)trackScrolling:(UIScrollView *)scrollView {
    self.scrollViewYOffset = MAX(scrollView.contentOffset.y, -(MAX(scrollView.contentInset.top, 0)));
    scrollView.showsVerticalScrollIndicator = [[self presentable] showsScrollableVerticalScrollIndicator];
}

/**
 * Halts the scroll of a given scroll view & anchors it at the `scrollViewYOffset`
 */
- (void)haltScrolling:(UIScrollView *)scrollView {
    
    //
    // Fix bug: the app will crash after the table view reloads data via calling [tableView reloadData] if the user scrolls to the bottom.
    //
    // We remove some element and reload data, for example, [self.dataSource removeLastObject], the previous saved scrollViewYOffset value
    // will be great than or equal to the current actual offset(i.e. scrollView.contentOffset.y). At this time, if the method
    // [scrollView setContentOffset:CGPointMake(0, self.scrollViewYOffset) animated:NO] is called, which will trigger KVO recursively.
    // So scrollViewYOffset must be less than or equal to the actual offset here.
    // See issues: https://github.com/HeathWang/HWPanModal/issues/107 and https://github.com/HeathWang/HWPanModal/issues/103
 
    if (scrollView.contentOffset.y <= 0 || self.scrollViewYOffset <= scrollView.contentOffset.y) {
        [scrollView setContentOffset:CGPointMake(0, self.scrollViewYOffset) animated:NO];
        scrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)didPanOnScrollViewChanged:(NSDictionary<NSKeyValueChangeKey, id> *)change {

    UIScrollView *scrollView = [[self presentable] panScrollable];
    if (!scrollView) return;
    
    if ((![self isBeingDismissed] && ![self isBeingPresented]) ||
        ([self isBeingDismissed] && [self isPresentedViewControllerInteractive])) {
        
        if (![self isPresentedViewAnchored] && scrollView.contentOffset.y > 0) {
            [self haltScrolling:scrollView];
        } else if ([scrollView isScrolling] || [self isPresentedViewAnimating]) {

            // While we're scrolling upwards on the scrollView, store the last content offset position
            if ([self isPresentedViewAnchored]) {
                [self trackScrolling:scrollView];
            } else {
                /**
                 * Keep scroll view in place while we're panning on main view
                 */
                [self haltScrolling:scrollView];
            }
        } else {
            [self trackScrolling:scrollView];
        }

    } else {
        /**
         * 当present Controller，而且动画没有结束的时候，用户可能会对scrollView设置contentOffset
         * 首次用户滑动scrollView时，会因为scrollViewYOffset = 0而出现错位
         */
         if ([self isBeingPresented]) {
             [self setScrollableContentOffset:scrollView.contentOffset animated:YES];
         }
    }
}

#pragma mark - UIScrollView update

- (void)configureScrollViewInsets {

    // when scrolling, return
    if ([self.presentable panScrollable] && ![self.presentable panScrollable].isScrolling) {
        UIScrollView *scrollView = [self.presentable panScrollable];
        // 禁用scrollView indicator除非用户开始滑动scrollView
        scrollView.showsVerticalScrollIndicator = [self.presentable showsScrollableVerticalScrollIndicator];
        scrollView.scrollEnabled = [self.presentable isPanScrollEnabled];
        scrollView.scrollIndicatorInsets = [self.presentable scrollIndicatorInsets];
        
        if (![self.presentable shouldAutoSetPanScrollContentInset]) return;
        
        UIEdgeInsets insets1 = scrollView.contentInset;
        CGFloat bottomLayoutOffset = [UIApplication sharedApplication].keyWindow.rootViewController.bottomLayoutGuide.length;
        /*
         * If scrollView has been set contentInset, and bottom is NOT zero, we won't change it.
         * If contentInset.bottom is zero, set bottom = bottomLayoutOffset
         * If scrollView has been set contentInset, BUT the bottom < bottomLayoutOffset, set bottom = bottomLayoutOffset
         */
        if (HW_FLOAT_IS_ZERO(insets1.bottom) || insets1.bottom < bottomLayoutOffset) {
            
            insets1.bottom = bottomLayoutOffset;
            scrollView.contentInset = insets1;
        }
        
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated {
    if (![self.presentable panScrollable]) return;

    UIScrollView *scrollView = [self.presentable panScrollable];
    [self.observerToken unObserver];

    [scrollView setContentOffset:offset animated:animated];
    // wait for animation finished.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) ((animated ? 0.30 : 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self trackScrolling:scrollView];
        [self observeScrollable];
    });

}

#pragma mark - layout

- (void)configureViewLayout {

    if ([self.presentable isKindOfClass:UIViewController.class]) {
        UIViewController<HWPanModalPresentable> *layoutPresentable = (UIViewController<HWPanModalPresentable> *) self.presentable;
        self.shortFormYPosition = layoutPresentable.shortFormYPos;
        self.mediumFormYPosition = layoutPresentable.mediumFormYPos;
        self.longFormYPosition = layoutPresentable.longFormYPos;
        self.anchorModalToLongForm = [layoutPresentable anchorModalToLongForm];
        self.extendsPanScrolling = [layoutPresentable allowsExtendedPanScrolling];
    } else if ([self.presentable isKindOfClass:HWPanModalContentView.class]) {
        HWPanModalContentView<HWPanModalPresentable> *layoutPresentable = (HWPanModalContentView<HWPanModalPresentable> *) self.presentable;
        self.shortFormYPosition = layoutPresentable.shortFormYPos;
        self.mediumFormYPosition = layoutPresentable.mediumFormYPos;
        self.longFormYPosition = layoutPresentable.longFormYPos;
        self.anchorModalToLongForm = [layoutPresentable anchorModalToLongForm];
        self.extendsPanScrolling = [layoutPresentable allowsExtendedPanScrolling];
    }

}

#pragma mark - UIGestureRecognizerDelegate

/**
 * ONLY When otherGestureRecognizer is panGestureRecognizer, and target gestureRecognizer is panGestureRecognizer, return YES.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self.presentable respondsToSelector:@selector(hw_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.presentable hw_gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        return [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class];
    }
    return NO;
}

/**
 * 当前手势为screenGestureRecognizer时，其他pan recognizer都应该fail
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self.presentable respondsToSelector:@selector(hw_gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:)]) {
        return [self.presentable hw_gestureRecognizer:gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:otherGestureRecognizer];
    }
    
    
    if (gestureRecognizer == self.screenEdgeGestureRecognizer && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.presentable respondsToSelector:@selector(hw_gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)]) {
        return [self.presentable hw_gestureRecognizer:gestureRecognizer shouldRequireFailureOfGestureRecognizer:otherGestureRecognizer];
    }

    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self.presentable respondsToSelector:@selector(hw_gestureRecognizerShouldBegin:)]) {
        return [self.presentable hw_gestureRecognizerShouldBegin:gestureRecognizer];
    }
    
    if (gestureRecognizer == self.screenEdgeGestureRecognizer) {
        CGPoint velocity = [self.screenEdgeGestureRecognizer velocityInView:self.screenEdgeGestureRecognizer.view];

        if (velocity.x <= 0 || HW_TWO_FLOAT_IS_EQUAL(velocity.x, 0)) {
            return NO;
        }

        // check the distance to left edge
        CGPoint location = [self.screenEdgeGestureRecognizer locationInView:self.screenEdgeGestureRecognizer.view];
        CGFloat thresholdDistance = [[self presentable] maxAllowedDistanceToLeftScreenEdgeForPanInteraction];
        if (thresholdDistance > 0 && location.x > thresholdDistance) {
            return NO;
        }

        if (velocity.x > 0 && HW_TWO_FLOAT_IS_EQUAL(velocity.y, 0)) {
            return YES;
        }

        //TODO: this logic can be updated later.
        if (velocity.x > 0 && velocity.x / fabs(velocity.y) > 2) {
            return YES;
        }
        return NO;
    }

    return YES;
}

#pragma mark - UIKeyboard Handle

- (void)addKeyboardObserver {
    if ([self.presentable isAutoHandleKeyboardEnabled]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    UIView<UIKeyInput> *currentInput = [self findCurrentTextInputInView:self.presentedView];

    if (!currentInput)
        return;

    self.keyboardInfo = notification.userInfo;
    [self updatePanContainerFrameForKeyboard];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardInfo = nil;

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve) [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];

    self.presentedView.transform = CGAffineTransformIdentity;

    [UIView commitAnimations];
}

- (void)updatePanContainerFrameForKeyboard {
    if (!self.keyboardInfo)
        return;

    UIView<UIKeyInput> *textInput = [self findCurrentTextInputInView:self.presentedView];
    if (!textInput)
        return;

    CGAffineTransform lastTransform = self.presentedView.transform;
    self.presentedView.transform = CGAffineTransformIdentity;

    CGFloat textViewBottomY = [textInput convertRect:textInput.bounds toView:self.presentedView].origin.y + textInput.hw_height;
    CGFloat keyboardHeight = [self.keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    CGFloat offsetY = 0;
    CGFloat top = [self.presentable keyboardOffsetFromInputView];
    offsetY = self.presentedView.hw_height - (keyboardHeight + top + textViewBottomY + self.presentedView.hw_top);

    NSTimeInterval duration = [self.keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve) [self.keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

    self.presentedView.transform = lastTransform;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];

    self.presentedView.transform = CGAffineTransformMakeTranslation(0, offsetY);

    [UIView commitAnimations];
}

- (UIView <UIKeyInput> *)findCurrentTextInputInView:(UIView *)view {
    if ([view conformsToProtocol:@protocol(UIKeyInput)] && view.isFirstResponder) {
        // Quick fix for web view issue
        if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")] || [view isKindOfClass:NSClassFromString(@"WKContentView")]) {
            return nil;
        }
        return (UIView <UIKeyInput> *) view;
    }

    for (UIView *subview in view.subviews) {
        UIView <UIKeyInput> *inputInView = [self findCurrentTextInputInView:subview];
        if (inputInView) {
            return inputInView;
        }
    }
    return nil;
}

#pragma mark - delegate throw

- (void)transitionToState:(PresentationState)state {

    id <HWPanModalPresentableHandlerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(presentableTransitionToState:)]) {
        [delegate presentableTransitionToState:state];
    }
}

- (void)cancelInteractiveTransition {
    id <HWPanModalPresentableHandlerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(cancelInteractiveTransition)]) {
        [delegate cancelInteractiveTransition];
    }
}

- (void)finishInteractiveTransition {
    id <HWPanModalPresentableHandlerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(finishInteractiveTransition)]) {
        [delegate finishInteractiveTransition];
    }
}

- (void)dismissPresentable:(BOOL)isInteractive mode:(PanModalInteractiveMode)mode {
    id <HWPanModalPresentableHandlerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dismiss:mode:)]) {
        [delegate dismiss:isInteractive mode:mode];
    }
}

#pragma mark - dataSource handle

- (BOOL)isPresentedViewAnchored {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isPresentedViewAnchored)]) {
        return [self.dataSource isPresentedViewAnchored];
    }

    return NO;
}

- (BOOL)isBeingDismissed {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isBeingDismissed)]) {
        return [self.dataSource isBeingDismissed];
    }
    return NO;
}

- (BOOL)isBeingPresented {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isBeingPresented)]) {
        return [self.dataSource isBeingPresented];
    }
    return NO;
}

- (BOOL)isPresentedViewControllerInteractive {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isPresentedControllerInteractive)]) {
        return [self.dataSource isPresentedControllerInteractive];
    }
    return NO;
}

- (BOOL)isPresentedViewAnimating {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isFormPositionAnimating)]) {
        [self.dataSource isFormPositionAnimating];
    }
    return NO;
}

- (CGSize)containerSize {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(containerSize)]) {
        return [self.dataSource containerSize];
    }

    return CGSizeZero;
}

#pragma mark - Getter

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnView:)];
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

- (UIPanGestureRecognizer *)screenEdgeGestureRecognizer {
    if (!_screenEdgeGestureRecognizer) {
        _screenEdgeGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgeInteractiveAction:)];
        _screenEdgeGestureRecognizer.minimumNumberOfTouches = 1;
        _screenEdgeGestureRecognizer.maximumNumberOfTouches = 1;
        _screenEdgeGestureRecognizer.delegate = self;
    }

    return _screenEdgeGestureRecognizer;
}

- (CGFloat)anchoredYPosition {
    CGFloat defaultTopOffset = [self.presentable topOffset];
    return self.anchorModalToLongForm ? self.longFormYPosition : defaultTopOffset;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self removeKeyboardObserver];
}

@end
