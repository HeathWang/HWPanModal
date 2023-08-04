//
//  HWPanModalPresentable.h
//  Pods
//
//  Created by heath wang on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalHeight.h>
#import <HWPanModal/HWPresentingVCAnimatedTransitioning.h>
#import <HWPanModal/HWPanModalIndicatorProtocol.h>
#import <HWPanModal/HWBackgroundConfig.h>
#import <HWPanModal/HWPanModalShadow.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PresentationState) {
	PresentationStateShort NS_SWIFT_NAME(short),
    PresentationStateMedium NS_SWIFT_NAME(medium),
	PresentationStateLong NS_SWIFT_NAME(long),
};

typedef NS_ENUM(NSInteger, PresentingViewControllerAnimationStyle) {
    // no animation for presentingVC
    PresentingViewControllerAnimationStyleNone NS_SWIFT_NAME(none),
    // page sheet animation, like iOS13 default modalPresentation style
    PresentingViewControllerAnimationStylePageSheet NS_SWIFT_NAME(pageSheet),
    // shopping cart animation, like jd/taobao shopping cart animation
    PresentingViewControllerAnimationStyleShoppingCart NS_SWIFT_NAME(shoppingCart),
    // make your own custom animation
    PresentingViewControllerAnimationStyleCustom NS_SWIFT_NAME(custom),
};

/**
 * HWPanModalPresentable为present配置协议
 * 默认情况下无需实现，只需Controller/View适配该协议
 * 通过category来默认实现以下所有方法，避免继承类
 *
 * This Protocol is the core of HWPanModal, we use it to config presentation.
 * Default, you don't need to conform all of these methods, just implement what you want to customize.
 * All the config has default value, we use a `UIViewController` category to conform `HWPanModalPresentable` protocol.
 */
@protocol HWPanModalPresentable <NSObject>

#pragma mark - ScrollView Config

/**
 * 支持同步拖拽的scrollView
 * 如果ViewController中包含scrollView并且你想scrollView滑动和拖拽手势同时存在，请返回此scrollView
 *
 * If your ViewController has a scrollable view(UIScrollView and subclass), and you want pan gesture and scrollable both work, return it.
 */
- (nullable UIScrollView *)panScrollable;

/**
 * determine ScrollView scrollEnabled
 * default is YES
 */
- (BOOL)isPanScrollEnabled;

/**
 * scrollView指示器insets
 * Use `panModalSetNeedsLayoutUpdate()` when updating insets.
 */
- (UIEdgeInsets)scrollIndicatorInsets;

/**
 * A Boolean value that controls whether the scrollable vertical scroll indicator is visible.
 * default is YES.
 */
- (BOOL)showsScrollableVerticalScrollIndicator;

/**
 * default is YES.
 */
- (BOOL)shouldAutoSetPanScrollContentInset;

/**
 * 是否允许拖动额外拖动，如果panScrollable存在，且scrollView contentSize > (size + bottomLayoutOffset),返回YES
 * 其余情况返回NO
 *
 * If panScrollable exists, and scrollView contentSize > (size + bottomLayoutOffset), auto return YES, otherwise return NO.
 * You can make your own logic if you want, and you know what you are doing.
 */
- (BOOL)allowsExtendedPanScrolling;

#pragma mark - Offset/position

/**
 * Screen top offset from presented viewController
 * Default is topLayoutGuide.length + 21.0.
 */
- (CGFloat)topOffset;

/**
 * 当pan状态为short时候的高度
 * default: shortFormHeight = longFormHeight
 */
- (PanModalHeight)shortFormHeight;

/**
 * default: mediumFormHeight = longFormHeight
 */
- (PanModalHeight)mediumFormHeight;

/**
 * 当pan状态为long的高度
 */
- (PanModalHeight)longFormHeight;

/**
 * 初始弹出高度状态，默认为`shortFormHeight`
 *
 * Origin presentation height state, if you have special requirement, change it.
 * Default is `shortFormHeight`
 */
- (PresentationState)originPresentationState;

#pragma mark - Animation config

/**
 * spring弹性动画数值
 * Default is 0.9
 */
- (CGFloat)springDamping;

/**
 * 转场动画时间
 * Default is 0.5 second
 */
- (NSTimeInterval)transitionDuration;

/**
 * starting from version 0.6.5, Only works when dismiss
 * Default is same as `- (NSTimeInterval)transitionDuration;`
 */
- (NSTimeInterval)dismissalDuration;

/**
 * 转场动画options
 * Default is UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
 */
- (UIViewAnimationOptions)transitionAnimationOptions;

#pragma mark - AppearanceTransition

/**
 * If enabled, the presenting VC will invoke viewWillAppear:, viewWillDisappear:
 * Default is YES
 */
- (BOOL)shouldEnableAppearanceTransition;

#pragma mark - Background config

/**
 * use this object to config background alpha or blur effect
 * @return background config object
 */
- (HWBackgroundConfig *)backgroundConfig;

#pragma mark - User Interaction

/**
 * 该bool值控制当pan View状态为long的情况下，是否可以继续拖拽到PanModalHeight = MAX的情况
 * 默认为YES,即当已经拖拽到long的情况下不能再继续拖动
 */
- (BOOL)anchorModalToLongForm;

/**
 * 是否允许点击背景处dismiss presented Controller
 * 默认为YES
 */
- (BOOL)allowsTapBackgroundToDismiss;


/**
 * 是否允许drag操作dismiss presented Controller
 * Default is YES
 */
- (BOOL)allowsDragToDismiss;

/// Default is YES, When return NO, and you did set shortForm, user CAN NOT pull down the view.
- (BOOL)allowsPullDownWhenShortState;

/**
 min Velocity from Vertical direction that trigger dismiss action.
 Default is 300.0
 */
- (CGFloat)minVerticalVelocityToTriggerDismiss;

/**
 * 是否允许用户操作
 * Default is YES
 */
- (BOOL)isUserInteractionEnabled;

/**
 * 是否允许触觉反馈
 * Default is YES
 */
- (BOOL)isHapticFeedbackEnabled;

/**
 * 是否允许触摸事件透传到presenting ViewController/View。如果你有特殊需求的话(比如弹出一个底部视图，但是你想操作弹出视图下面的view，即presenting VC/View)，可开启此功能
 *
 * Whether allows touch events passing through the transition container view.
 * In some situations, you present the bottom VC/View, and you want to operate the presenting VC/View(mapView, scrollView and etc), enable this func.
 *
 * Note: You SHOULD MUST dismiss the presented VC in the right time.
 */
- (BOOL)allowsTouchEventsPassingThroughTransitionView;

#pragma mark - Screen left egde interaction

/**
 * 是否允许屏幕边缘侧滑手势
 * Default is NO，not allowed this user interaction.
 *
 * Note: Currently only works on UIViewController.
 */
- (BOOL)allowScreenEdgeInteractive;

/**
 * Max allowed distance to screen left edge when you want to make screen edge pan interaction
 * Default is 0, means it will ignore this limit, full screen left edge pan will work.
 * @return distance to left screen edge
 */
- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction;

/**
 * When you enabled `- (BOOL)allowScreenEdgeInteractive`, this can work.
 * min horizontal velocity to trigger screen edge dismiss if the drag didn't reach 0.5 screen width.
 * Default is 500
 */
- (CGFloat)minHorizontalVelocityToTriggerScreenEdgeDismiss;

#pragma mark - Customize presentingViewController animation

/**
 * Config presentingViewController animation style, this animations will work for present & dismiss.
 * Default is `PresentingViewControllerAnimationStyleNone`.
 * @return The animation style.
 */
- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle;

/**
 * 自定义presenting ViewController转场动画，默认为nil
 * 注意：如果实现该方法并返回非空示例，要使该方法生效，`- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle`必须返回PresentingViewControllerAnimationStyleCustom
 *
 * custom presenting ViewController transition animation, default is nil
 * Note: If you implement this method and return non nil value, You must implement  `- (PresentingViewControllerAnimationStyle)
 * presentingVCAnimationStyle` and return PresentingViewControllerAnimationStyleCustom
 */
- (nullable id<HWPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation;

#pragma mark - Content UI config

/**
 * 是否顶部圆角
 * Default is YES
 */
- (BOOL)shouldRoundTopCorners;

/**
 * 顶部圆角数值
 * Default is 8.0
 */
- (CGFloat)cornerRadius;

/**
* presented content shadow
* Default is None config
*/
- (HWPanModalShadow *)contentShadow;

#pragma mark - Indicator config

/**
 * 是否显示drag指示view
 * Default is YES，Default this method depend on `- (BOOL)shouldRoundTopCorners`
 */
- (BOOL)showDragIndicator;

/**
 * You can make the indicator customized. Just adopt `HWPanModalIndicatorProtocol`
 * Default this method return nil, Then the default indicator will be used.
 */
- (__kindof UIView<HWPanModalIndicatorProtocol> * _Nullable)customIndicatorView;

#pragma mark - Keyboard handle

/**
 * When there is text input view exists and becomeFirstResponder, will auto handle keyboard height.
 * Default is YES. You can disable it, handle it by yourself.
 */
- (BOOL)isAutoHandleKeyboardEnabled;

/**
 The offset that keyboard show from input view's bottom. It works when
 `isAutoHandleKeyboardEnabled` return YES.

 @return offset, default is 5.
 */
- (CGFloat)keyboardOffsetFromInputView;

#pragma mark - Delegate

#pragma mark - Pan Gesture delegate

/**
 * 询问delegate是否需要使拖拽手势生效
 * 若返回NO，则禁用拖拽手势操作，即不能拖拽dismiss
 * 默认为YES
 */
- (BOOL)shouldRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 当pan recognizer状态为begin/changed时，通知delegate回调。
 * 当拖动presented View时，该方法会持续的回调
 * 默认实现为空
 */
- (void)willRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 内部处理完成拖动操作后触发此回调，此时view frame可能已经变化。
 * Framework has did finish logic for GestureRecognizer delegate. It will call many times when you darg.
 */
- (void)didRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 内部处理完成拖动操作后触发此回调，此时view frame可能已经变化。
 * Framework has did finish logic for GestureRecognizer delegate. It will call many times when you darg.
 */
- (void)didEndRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 是否优先执行dismiss拖拽手势，当存在panScrollable的情况下，如果此方法返回YES，则
 * dismiss手势生效，scrollView本身的滑动则不再生效。也就是说可以拖动Controller view，而scrollView没法拖动了。
 *
 * 例子：controller view上添加一个TableView，并铺满全屏，然后在controller view 顶部添加一个一定大小的viewA，
 * 这个时候会发现viewA有时候无法拖动，可以实现此delegate方法来解决
 ```
 - (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint loc = [panGestureRecognizer locationInView:self.view];
    // check whether user pan action in viewA
    if (CGRectContainsPoint(self.viewA.frame, loc)) {
        return YES;
    }

    return NO;
}
 ```
 * 默认为NO
 *
 * This delegate is useful when you want panGestureRecognizer has a high prioritize and
 * make scrollable does NOT scroll.
 * Example: You controller add a full size tableView, then add viewA on top of your controller view.
 * Now you find you can not drag the viewA, use this delegate to resolve problem.
 * Please refer to code above this comment.
 *
 * Default is NO
 */
- (BOOL)shouldPrioritizePanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * When you pan present controller to dismiss, and the view's y <= shortFormYPos,
 * this delegate method will be called.
 * @param percent 0 ~ 1, 1 means has dismissed
 */
- (void)panModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent;

#pragma mark - PresentationState change delegate
/**
 * 是否应该变更panModal状态
 */
- (BOOL)shouldTransitionToState:(PresentationState)state;

/**
 *  called when the Transition State will change.
 * 通知回调即将变更状态
 */
- (void)willTransitionToState:(PresentationState)state;

/**
 * PresentationState did change callback
 */
- (void)didChangeTransitionToState:(PresentationState)state;

#pragma mark - present delegate

/**
 * call when present transition will begin.
 */
- (void)panModalTransitionWillBegin;

/**
 * call when present transition did finish.
 */
- (void)panModalTransitionDidFinish;

/**
 * call when your custom presented vc has been added to the presentation container.
 */
- (void)presentedViewDidMoveToSuperView;

#pragma mark - Dismiss delegate
/**
 * will dismiss
 */
- (void)panModalWillDismiss;

/**
 * Did finish dismissing
 */
- (void)panModalDidDismissed;

#pragma mark - DEPRECATED DECLARE

/**
 * 是否对presentingViewController做动画效果，默认该效果类似淘宝/京东购物车凹陷效果
 * 默认为NO
 */
- (BOOL)shouldAnimatePresentingVC DEPRECATED_MSG_ATTRIBUTE("This api has been marked as DEPRECATED on version 0.3.6, please use `- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle` replaced.");

/**
 * 背景透明度
 * Default is 0.7
 */
- (CGFloat)backgroundAlpha DEPRECATED_MSG_ATTRIBUTE("This api has been marked as DEPRECATED on version 0.7.0, please use `- (HWBackgroundConfig *)backgroundConfig` replaced.");

/**
 * Blur background
 * This function can NOT coexist with backgroundAlpha
 * Default use backgroundAlpha, Once you set backgroundBlurRadius > 0, blur will work.
 * Recommend set the value 10 ~ 20.
 * @return blur radius
 */
- (CGFloat)backgroundBlurRadius DEPRECATED_MSG_ATTRIBUTE("This api has been marked as DEPRECATED on version 0.7.0, please use `- (HWBackgroundConfig *)backgroundConfig` replaced.");

/**
 * blur background color
 * @return color, default is White Color.
 */
- (nonnull UIColor *)backgroundBlurColor DEPRECATED_MSG_ATTRIBUTE("This api has been marked as DEPRECATED on version 0.7.0, please use `- (HWBackgroundConfig *)backgroundConfig` replaced.");

@end


NS_ASSUME_NONNULL_END

