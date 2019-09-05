//
//  HWPanModalPresenterProtocol.h
//  Pods
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <HWPanModal/HWPanModalPresentable.h>
@class HWPanModalPresentationDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol HWPanModalPresenter <NSObject>

@property (nonatomic, assign, readonly) BOOL isPanModalPresented;
/**
 * 这里我们将实现UIViewControllerTransitioningDelegate协议的delegate通过runtime存入到viewControllerToPresent中。
 * use runtime to store this prop to hw_presentedVC
 */
@property (nonnull, nonatomic, strong) HWPanModalPresentationDelegate *hw_panModalPresentationDelegate;

/**
 * Note: This method ONLY for iPad, like UIPopoverPresentationController.
 */
- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent
             sourceView:(nullable UIView *)sourceView
             sourceRect:(CGRect)rect;

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent
             sourceView:(nullable UIView *)sourceView
             sourceRect:(CGRect)rect
             completion:(void (^ __nullable)(void))completion;

/**
 * Present the Controller from bottom.
 */
- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent;

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent
             completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END

