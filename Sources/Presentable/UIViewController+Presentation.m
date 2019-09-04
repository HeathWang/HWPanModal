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
    if (!self.presentedVC) return;
    [self.presentedVC transitionToState:state];
}

- (void)hw_panModalSetContentOffset:(CGPoint)offset {
    if (!self.presentedVC) return;
    [self.presentedVC setContentOffset:offset];
}

- (void)hw_panModalSetNeedsLayoutUpdate {
    if (![self conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        return;
    }
    if (!self.presentedVC) return;
    [self.presentedVC setNeedsLayoutUpdate];
}

@end
