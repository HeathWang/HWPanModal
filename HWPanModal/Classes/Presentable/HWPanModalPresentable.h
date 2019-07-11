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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PresentationState) {
	PresentationStateShort,
	PresentationStateLong,
};

typedef void(^AnimationBlockType)(void);
typedef void(^AnimationCompletionType)(BOOL completion);

/**
 * HWPanModalPresentable为present配置协议
 * 默认情况下无需实现，只需Controller conforms 该协议
 * 通过category来默认实现以下所有方法。这样就不用通过继承来实现protocol
 */
@protocol HWPanModalPresentable <NSObject>

#pragma mark - get config

/**
 * 支持同步拖拽的scrollView
 * 如果ViewController中包含scrollView并且你想scrollView滑动和拖拽手势同事存在，请返回此scrollView
 */
- (nullable UIScrollView *)panScrollable;

/**
 * offset：屏幕顶部距离
 * 默认为topLayoutGuide.length + 21.0.
 */
- (CGFloat)topOffset;

/**
 * 当pan状态为short时候的高度
 * 默认状态下，shortFormHeight = longFormHeight
 */
- (PanModalHeight)shortFormHeight;

/**
 * 当pan状态为long的高度
 */
- (PanModalHeight)longFormHeight;

/**
 * 该bool值控制当pan View状态为long的情况下，是否可以继续拖拽到PanModalHeight = MAX的情况
 * 默认为YES,即当已经拖拽到long的情况下不能再继续拖动
 */
- (BOOL)anchorModalToLongForm;

/**
 * spring弹性动画数值，默认未0.9
 */
- (CGFloat)springDamping;

/**
 * 转场动画时间，默认为0.5s
 */
- (NSTimeInterval)transitionDuration;

/**
 * 转场动画options
 * 默认为 UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
 */
- (UIViewAnimationOptions)transitionAnimationOptions;

/**
 * 背景透明度，默认为0.7
 */
- (CGFloat)backgroundAlpha;

/**
 * Blur background
 * This function can NOT coexist with backgroundAlpha
 * Default use backgroundAlpha, Once you set backgroundBlurRadius > 0, blur will work.
 * I recommend set the value 10 ~ 20.
 * @return blur radius
 */
- (CGFloat)backgroundBlurRadius;

/**
 * scrollView指示器insets
 * Use `panModalSetNeedsLayoutUpdate()` when updating insets.
 */
- (UIEdgeInsets)scrollIndicatorInsets;

/**
 * 是否允许拖动额外拖动，如果panScrollable存在，且scrollView contentSize > (size + bottomLayoutOffset),返回YES
 * 其余情况返回NO
 */
- (BOOL)allowsExtendedPanScrolling;

/**
 * 是否允许drag操作dismiss presented Controller
 * 默认为YES
 */
- (BOOL)allowsDragToDismiss;

/**
 * 是否允许点击背景处dismiss presented Controller
 * 默认为YES
 */
- (BOOL)allowsTapBackgroundToDismiss;

/**
 * 是否允许pan scroll view
 * 默认为YES
 */
- (BOOL)isPanScrollEnabled;

/**
 * 是否允许用户操作
 * 默认为YES
 */
- (BOOL)isUserInteractionEnabled;

/**
 * 是否允许屏幕边缘侧滑手势
 * 默认为NO，不允许
 */
- (BOOL)allowScreenEdgeInteractive;

/**
 * 是否对presentingViewController做动画效果，默认该效果类似淘宝/京东购物车凹陷效果
 * 默认为NO
 */
- (BOOL)shouldAnimatePresentingVC;

/**
 * 自定义presenting ViewController转场动画
 * 注意要使自定义效果生效，shouldAnimatePresentingVC 必须返回YES
 * 默认转场效果为凹陷动画效果，如果该方法返回不为空，则使用自定义动画效果
 * 默认为nil
 */
- (id<HWPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation;

/**
 * 是否允许触觉反馈
 * 默认为YES
 */
- (BOOL)isHapticFeedbackEnabled;

/**
 * 是否顶部圆角
 * 默认为YES
 */
- (BOOL)shouldRoundTopCorners;

/**
 * 顶部圆角数值
 * 默认为8.0
 */
- (CGFloat)cornerRadius;

/**
 * 是否显示drag指示view
 * 默认为YES，该属性默认取‘- (BOOL)shouldRoundTopCorners’
 */
- (BOOL)showDragIndicator;

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

#pragma mark - delegate

/**
 * 询问delegate是否需要使拖拽手势生效
 * 若返回NO，则禁用拖拽在presented view上
 * 默认为YES
 */
- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 当pan recognizer状态为begin/changed时，通知delegate回调。
 * 当拖动presented View时，该方法会持续的回调
 * 默认实现为空
 */
- (void)willRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 是否优先dismiss拖拽手势，当存在scrollView的情况下，如果此方法返回YES，则
 * dismiss手势生效，scrollView本身的滑动则不再生效。也就是说可以拖动Controller view，
 * 而scrollView没法拖动了
 *
 * 默认为NO
 */
- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 是否应该变更panModal状态
 */
- (BOOL)shouldTransitionToState:(PresentationState)state;

/**
 * 通知回调即将变更状态
 */
- (void)willTransitionToState:(PresentationState)state;

/**
 * When you pan present controller to dismiss, and the view's y <= shortFormYPos,
 * this delegate method will be called.
 * @param percent 0 ~ 1, 1 means has dismissed
 */
- (void)panModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent;

/**
 * 通知回调即将dismiss
 */
- (void)panModalWillDismiss;

@end

NS_ASSUME_NONNULL_END

