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
 * 这里我们将实现UIViewControllerTransitioningDelegate协议的delegate通过runtime存入
 * 到viewControllerToPresent中。
 */
@property (nonatomic, strong) HWPanModalPresentationDelegate *presentationDelegate;

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent sourceView:(nullable UIView *)sourceView sourceRect:(CGRect)rect;

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent;

@end

NS_ASSUME_NONNULL_END

