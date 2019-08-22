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
	return [UIApplication sharedApplication].keyWindow.rootViewController.topLayoutGuide.length;
}

- (CGFloat)bottomLayoutOffset {
	return [UIApplication sharedApplication].keyWindow.rootViewController.bottomLayoutGuide.length;
}

- (HWPanModalPresentationController *)presentedVC {
	if ([self.presentationController isKindOfClass:HWPanModalPresentationController.class]) {
		return (HWPanModalPresentationController *) self.presentationController;
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

- (CGFloat)longFormYPos {
	return MAX([self topMarginFromPanModalHeight:[self longFormHeight]], [self topMarginFromPanModalHeight:PanModalHeightMake(PanModalHeightTypeMax, 0)]) + [self topOffset];
}

/**
 * Use the container view for relative positioning as this view's frame
   is adjusted in PanModalPresentationController
 */
- (CGFloat)bottomYPos {
	if (self.presentedVC.containerView) {
		return self.presentedVC.containerView.bounds.size.height - [self topOffset];
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

            CGSize targetSize = CGSizeMake(self.presentedVC.containerView ? self.presentedVC.containerView.bounds.size.width : [UIScreen mainScreen].bounds.size.width, UILayoutFittingCompressedSize.height);
            CGFloat intrinsicHeight = [self.view systemLayoutSizeFittingSize:targetSize].height;
			return self.bottomYPos - (intrinsicHeight + self.bottomLayoutOffset);
		}
		default:
			return 0;
	}
}


@end
