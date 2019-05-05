//
//  HWPanModalPresenterProtocol.h
//  Pods
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HWPanModalPresentable.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HWPanModalPresenter <NSObject>

@property (nonatomic, assign, readonly) BOOL isPanModalPresented;

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent sourceView:(nullable UIView *)sourceView sourceRect:(CGRect)rect;

- (void)presentPanModal:(UIViewController<HWPanModalPresentable> *)viewControllerToPresent;

@end

NS_ASSUME_NONNULL_END

