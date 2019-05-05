//
//  HWPanContainerView.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWPanContainerView.h"

@implementation HWPanContainerView

- (instancetype)initWithPresentedView:(UIView *)presentedView frame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:presentedView];
    }
	
    return self;
}

@end

@implementation UIView (PanContainer)

- (HWPanContainerView *)panContainerView {
	for (UIView *subview in self.subviews) {
		if ([subview isKindOfClass:HWPanContainerView.class]) {
			return (HWPanContainerView *) subview;
		}
	}
	return nil;
}


@end
