//
//  UIViewController+Presentation.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+Presentation.h"
#import "HWPanModalAnimator.h"
#import "UIViewController+LayoutHelper.h"
#import "HWPanModalPresentationController.h"

@interface UIViewController ()

@end

@implementation UIViewController (Presentation)

- (void)hw_panModalTransitionTo:(PresentationState)state {
    [self.presentedVC transitionToState:state];
}

- (void)hw_panModalSetContentOffset:(CGPoint)offset {
    [self.presentedVC setContentOffset:offset];
}

- (void)hw_panModalSetNeedsLayoutUpdate {
    [self.presentedVC setNeedsLayoutUpdate];
}

- (void)hw_panModalAnimate:(AnimationBlockType)block completion:(AnimationCompletionType)completion {
    [HWPanModalAnimator animate:block config:(id <HWPanModalPresentable>) self completion:completion];
}

@end
