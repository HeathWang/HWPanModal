//
//  HWPanModalPresentationDelegate.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalPresentationDelegate : NSObject <UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
