//
//  UIViewController+Presentation.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>
#import <HWPanModal/HWPanModalPresentationUpdateProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The presented Controller can use the category to update UIPresentationController container.
 */
@interface UIViewController (Presentation) <HWPanModalPresentationUpdateProtocol>

@end

NS_ASSUME_NONNULL_END
