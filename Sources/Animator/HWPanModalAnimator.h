//
//  HWPanModalAnimator.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import <HWPanModal/HWPanModalPresentable.h>

NS_ASSUME_NONNULL_BEGIN

static NSTimeInterval kTransitionDuration = 0.5;

@interface HWPanModalAnimator : NSObject

+ (void)animate:(AnimationBlockType)animations config:(nullable id <HWPanModalPresentable>)config completion:(nullable AnimationCompletionType)completion;

+ (void)smoothAnimate:(AnimationBlockType)animations completion:(nullable AnimationCompletionType)completion;
@end

NS_ASSUME_NONNULL_END
