//
//  UIViewController+LayoutHelper.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "UIViewController+LayoutHelper.h"
#import "HWPanModalPresentationController.h"
#import "UIViewController+PanModalDefault.h"

@implementation UIViewController (LayoutHelper)

- (CGFloat)topLayoutOffset {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    } else {
        return [UIApplication sharedApplication].keyWindow.rootViewController.topLayoutGuide.length;
    }
	
}

- (CGFloat)bottomLayoutOffset {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        return [UIApplication sharedApplication].keyWindow.rootViewController.bottomLayoutGuide.length;
    }
}

- (HWPanModalPresentationController *)hw_presentedVC {
    /*
     * Fix iOS13 bug: if we access presentationController before present VC, this will lead `modalPresentationStyle` not working.
     * refer to: https://github.com/HeathWang/HWPanModal/issues/27
     * Apple Doc: If you have not yet presented the current view controller, accessing this property creates a presentation controller based on the current value in the modalPresentationStyle property.
     */
    
    /**
     * fix bug: https://github.com/HeathWang/HWPanModal/issues/37
     */
    if (self.presentingViewController) {
        return [self hw_getPanModalPresentationController];
    } else {
        return nil;
    }
}

- (HWPanModalPresentationController *)hw_getPanModalPresentationController {
    UIViewController *ancestorsVC;
    
    // seeking for the root presentation VC.
    if (self.splitViewController) {
        ancestorsVC = self.splitViewController;
    } else if (self.navigationController) {
        ancestorsVC = self.navigationController;
    } else if (self.tabBarController) {
        ancestorsVC = self.tabBarController;
    } else {
        ancestorsVC = self;
    }
    
    if ([ancestorsVC.presentationController isMemberOfClass:HWPanModalPresentationController.class]) {
        return (HWPanModalPresentationController *) ancestorsVC.presentationController;
    }
    return nil;
}

/**
 Returns the short form Y postion

 - Note: If voiceover is on, the `longFormYPos` is returned.
 We do not support short form when voiceover is on as it would make it difficult for user to navigate.
*/
- (CGFloat)shortFormYPos {
    if (UIAccessibilityIsVoiceOverRunning()) {
        return self.longFormYPos;
    } else {
    	CGFloat shortFormYPos = [self topMarginFromPanModalHeight:[self shortFormHeight]] + [self topOffset];
		return MAX(shortFormYPos, self.longFormYPos);
    }
}

- (CGFloat)mediumFormYPos {
    if (UIAccessibilityIsVoiceOverRunning()) {
        return self.longFormYPos;
    } else {
        CGFloat mediumFormYPos = [self topMarginFromPanModalHeight:[self mediumFormHeight]] + [self topOffset];
        return MAX(mediumFormYPos, self.longFormYPos);
    }
}

- (CGFloat)longFormYPos {
	return MAX([self topMarginFromPanModalHeight:[self longFormHeight]], [self topMarginFromPanModalHeight:PanModalHeightMake(PanModalHeightTypeMax, 0)]) + [self topOffset];
}

/**
 * Use the container view for relative positioning as this view's frame
   is adjusted in PanModalPresentationController
 */
- (CGFloat)bottomYPos {
	if (self.hw_presentedVC.containerView) {
		return self.hw_presentedVC.containerView.bounds.size.height - [self topOffset];
	}
	return self.view.bounds.size.height;
}

- (CGFloat)topMarginFromPanModalHeight:(PanModalHeight)panModalHeight {
	switch (panModalHeight.heightType) {
		case PanModalHeightTypeMax:
			return 0.0f;
		case PanModalHeightTypeMaxTopInset:
			return panModalHeight.height;
		case PanModalHeightTypeContent:
			return self.bottomYPos - (panModalHeight.height + self.bottomLayoutOffset);
		case PanModalHeightTypeContentIgnoringSafeArea:
			return self.bottomYPos - panModalHeight.height;
		case PanModalHeightTypeIntrinsic:
		{
			[self.view layoutIfNeeded];

            CGSize targetSize = CGSizeMake(self.hw_presentedVC.containerView ? self.hw_presentedVC.containerView.bounds.size.width : [UIScreen mainScreen].bounds.size.width, UILayoutFittingCompressedSize.height);
            CGFloat intrinsicHeight = [self.view systemLayoutSizeFittingSize:targetSize].height;
			return self.bottomYPos - (intrinsicHeight + self.bottomLayoutOffset);
		}
		default:
			return 0;
	}
}

@end
