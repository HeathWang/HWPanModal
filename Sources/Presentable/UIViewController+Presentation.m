//
//  UIViewController+Presentation.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+Presentation.h"
#import "UIViewController+LayoutHelper.h"
#import "HWPanModalPresentationController.h"

@interface UIViewController ()

@end

@implementation UIViewController (Presentation)

- (void)hw_panModalTransitionTo:(PresentationState)state {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC transitionToState:state animated:YES];
}

- (void)hw_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC transitionToState:state animated:animated];
}

- (void)hw_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC setScrollableContentOffset:offset animated:animated];
}


- (void)hw_panModalSetContentOffset:(CGPoint)offset {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC setScrollableContentOffset:offset animated:YES];
}

- (void)hw_panModalSetNeedsLayoutUpdate {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC setNeedsLayoutUpdate];
}

- (void)hw_panModalUpdateUserHitBehavior {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC updateUserHitBehavior];
}

- (void)hw_dismissAnimated:(BOOL)animated completion:(void (^)(void))completion{
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC dismissAnimated:animated completion:completion];
}

- (HWDimmedView *)hw_dimmedView {
    return self.hw_presentedVC.backgroundView;
}

- (UIView *)hw_rootContainerView {
    return self.hw_presentedVC.containerView;
}

- (UIView *)hw_contentView {
    return self.hw_presentedVC.presentedView;
}

- (PresentationState)hw_presentationState {
    return self.hw_presentedVC.currentPresentationState;
}

@end
