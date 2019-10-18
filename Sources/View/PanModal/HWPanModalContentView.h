//
//  HWPanModalContentView.h
//  Pods
//
//  Created by heath wang on 2019/10/17.
//

#import <UIKit/UIKit.h>
#import <HWPanModal/HWPanModalPresentable.h>
#import <HWPanModal/HWPanModalPresentationUpdateProtocol.h>
#import <HWPanModal/UIViewController+LayoutHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalContentView : UIView <HWPanModalPresentable, HWPanModalPresentationUpdateProtocol, HWPanModalPresentableLayoutProtocol>

/**
 * present in the target view
 * @param view The view which present to.
 */
- (void)presentInView:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
