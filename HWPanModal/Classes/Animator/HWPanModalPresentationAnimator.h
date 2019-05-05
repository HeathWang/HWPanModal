//
//  HWPanModalPresentationAnimator.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransitionStyle) {
	TransitionStylePresentation,
	TransitionStyleDismissal,
};

NS_ASSUME_NONNULL_BEGIN

@interface HWPanModalPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTransitionStyle:(TransitionStyle)transitionStyle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
