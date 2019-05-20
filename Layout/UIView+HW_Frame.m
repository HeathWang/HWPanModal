//
//  UIView+HW_Frame.m
//  HWPanModal
//
//  Created by heath wang on 2019/5/20.
//

#import "UIView+HW_Frame.h"

@implementation UIView (HW_Frame)

- (CGFloat)hw_left {
	return self.frame.origin.x;
}

- (void)setHw_left:(CGFloat)hwLeft {
	CGRect frame = self.frame;
    frame.origin.x = hwLeft;
    self.frame = frame;
}

- (CGFloat)hw_top {
	return self.frame.origin.y;
}

- (void)setHw_top:(CGFloat)hwTop {
    CGRect frame = self.frame;
    frame.origin.y = hwTop;
    self.frame = frame;
}

- (CGFloat)hw_right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setHw_right:(CGFloat)hwRight {
    CGRect frame = self.frame;
    frame.origin.x = hwRight - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)hw_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setHw_bottom:(CGFloat)hwBottom {
    CGRect frame = self.frame;
    frame.origin.y = hwBottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)hw_width {
	return self.frame.size.width;
}

- (void)setHw_width:(CGFloat)hwWidth {
    CGRect frame = self.frame;
    frame.size.width = hwWidth;
    self.frame = frame;
}

- (CGFloat)hw_height {
	return self.frame.size.height;
}

- (void)setHw_height:(CGFloat)hwHeight {
    CGRect frame = self.frame;
    frame.size.height = hwHeight;
    self.frame = frame;
}

- (CGFloat)hw_centerX {
	return self.center.x;
}

- (void)setHw_centerX:(CGFloat)hwCenterX {
    self.center = CGPointMake(hwCenterX, self.center.y);
}

- (CGFloat)hw_centerY {
	return self.center.y;
}

- (void)setHw_centerY:(CGFloat)hwCenterY {
    self.center = CGPointMake(self.center.x, hwCenterY);
}

- (CGPoint)hw_origin {
	return self.frame.origin;
}

- (void)setHw_origin:(CGPoint)hwOrigin {
    CGRect frame = self.frame;
    frame.origin = hwOrigin;
    self.frame = frame;
}

- (CGSize)hw_size {
	return self.frame.size;
}

- (void)setHw_size:(CGSize)hwSize {
    CGRect frame = self.frame;
    frame.size = hwSize;
    self.frame = frame;
}


@end
