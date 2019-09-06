//
//  HWPanModalPresentationAnimator.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HWPanModalPresentationDelegate.h"

typedef NS_ENUM(NSInteger, TransitionStyle) {
	TransitionStylePresentation,
	TransitionStyleDismissal,
};

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionStyle:(TransitionStyle)transitionStyle interactiveMode:(PanModalInteractiveMode)mode;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
