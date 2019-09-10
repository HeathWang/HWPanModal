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
    [self.hw_presentedVC transitionToState:state];
}

- (void)hw_panModalSetContentOffset:(CGPoint)offset {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC setScrollableContentOffset:offset];
}

- (void)hw_panModalSetNeedsLayoutUpdate {
    if (!self.hw_presentedVC) return;
    [self.hw_presentedVC setNeedsLayoutUpdate];
}

@end
