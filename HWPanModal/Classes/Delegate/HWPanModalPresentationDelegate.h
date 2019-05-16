//
//  HWPanModalPresentationDelegate.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HWPanModalInteractiveAnimator;

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalPresentationDelegate : NSObject <UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>

/**
 * if user do Screen Pan recognizer, interactive = YES
 */
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, strong, readonly) HWPanModalInteractiveAnimator *interactiveDismissalAnimator;

@end

NS_ASSUME_NONNULL_END
