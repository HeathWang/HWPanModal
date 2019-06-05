//
//  HWPanModalPresentable.h
//  Pods
//
//  Created by heath wang on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalHeight.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PresentationState) {
	PresentationStateShort,
	PresentationStateLong,
};

typedef void(^AnimationBlockType)(void);
typedef void(^AnimationCompletionType)(BOOL completion);

/**
 * HWPanModalPresentable为present配置协议
 * 默认情况下无需实现，只需Controller conform 该协议
 * 因为oc的特性问题，以下可以被定义为只读属性的，被定义成方法。
 * 我们通过category来默认实现以下所有方法。这样就不用通过继承来实现protocol
 */

@protocol HWPanModalPresentable <NSObject>

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
 * spring弹性动画数值，默认未0.9
 */
- (CGFloat)springDamping;

/**
 * 背景透明度，默认为0.8
 */
- (CGFloat)backgroundAlpha;

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
 * scrollView指示器insets
 * Use `panModalSetNeedsLayoutUpdate()` when updating insets.
 */
- (UIEdgeInsets)scrollIndicatorInsets;

/**
 * 该bool值控制当pan View状态为long的情况下，是否可以继续拖拽到PanModalHeight = MAX的情况
 * 默认为YES,即当已经拖拽到long的情况下不能再继续拖动
 */
- (BOOL)anchorModalToLongForm;

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
 * 是否对presentingViewController做动画效果，该效果类似淘宝/京东购物车凹陷效果
 * 默认为NO
 */
- (BOOL)shouldAnimatePresentingVC;

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

#pragma mark - delegate & dataSource

/**
 * 询问delegate是否需要response pan recognizer 在 pan Modal上
 * 若返回NO，则禁用拖拽在presented view上，但pan gesture recognizer依然生效
 * 默认为YES
 */
- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 当pan recognizer状态为begin/changed时，通知delegate回调。
 * 例如scroll view准备滑动
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
 * 通知回调即将dismiss
 */
- (void)panModalWillDismiss;

@end

NS_ASSUME_NONNULL_END

