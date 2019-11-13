//
//  HWPanModalAnimator.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import <HWPanModal/HWPanModalPresentable.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AnimationBlockType)(void);
typedef void(^AnimationCompletionType)(BOOL completion);

static NSTimeInterval kTransitionDuration = 0.5;

@interface HWPanModalAnimator : NSObject

+ (void)animate:(AnimationBlockType)animations config:(nullable id <HWPanModalPresentable>)config completion:(nullable AnimationCompletionType)completion;

+ (void)dismissAnimate:(AnimationBlockType)animations config:(nullable id <HWPanModalPresentable>)config completion:(AnimationCompletionType)completion;

+ (void)smoothAnimate:(AnimationBlockType)animations duration:(NSTimeInterval)duration completion:(nullable AnimationCompletionType)completion;
@end

NS_ASSUME_NONNULL_END
