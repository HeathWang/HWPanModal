//
//  UIViewController+LayoutHelper.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
@class HWPanModalPresentationController;

NS_ASSUME_NONNULL_BEGIN

/**
 * 该category为实现了HWPanModalPresentable的Controller使用
 */
@interface UIViewController (LayoutHelper)

@property (nonatomic, assign, readonly) CGFloat topLayoutOffset;

@property (nonatomic, assign, readonly) CGFloat bottomLayoutOffset;

@property (nullable, nonatomic, strong, readonly) HWPanModalPresentationController *presentedVC;

@property (nonatomic, assign, readonly) CGFloat shortFormYPos;

@property (nonatomic, assign, readonly) CGFloat longFormYPos;

@property (nonatomic, assign, readonly) CGFloat bottomYPos;

@end

NS_ASSUME_NONNULL_END
