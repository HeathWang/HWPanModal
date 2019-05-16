//
//  HWPanIndicatorView.m
//  HWPanModal
//
//  Created by heath wang on 2019/5/16.
//

#import "HWPanIndicatorView.h"

@interface HWPanIndicatorView ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation HWPanIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:self.leftView];
		[self addSubview:self.rightView];
		self.color = [UIColor colorWithRed:0.792 green:0.788 blue:0.812 alpha:1.00];
	}

	return self;
}

- (void)sizeToFit {
	[super sizeToFit];

	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 34, 13);
	CGFloat height = 5;
	CGFloat correction = height / 2;

	self.leftView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2 + correction, height);
	CGPoint leftCenter = self.leftView.center;
	leftCenter.y = self.frame.size.height / 2;
	self.leftView.center = leftCenter;
	self.leftView.layer.cornerRadius = MIN(CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame)) / 2;

	self.rightView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - correction, 0, CGRectGetWidth(self.frame) / 2 + correction, height);
	CGPoint rightCenter = self.rightView.center;
	rightCenter.y = self.frame.size.height / 2;
	self.rightView.center = rightCenter;
	self.rightView.layer.cornerRadius = MIN(CGRectGetWidth(self.rightView.frame), CGRectGetHeight(self.rightView.frame)) / 2;
}

- (void)animate:(void (^)(void))animations {
	[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:animations completion:^(BOOL finished) {

	}];
}

#pragma mark - Getter

- (UIView *)leftView {
	if (!_leftView) {
		_leftView = [UIView new];
	}
	return _leftView;
}

- (UIView *)rightView {
	if (!_rightView) {
		_rightView = [UIView new];
	}
	return _rightView;
}


#pragma mark - Setter

- (void)setColor:(UIColor *)color {
	_color = color;
	self.leftView.backgroundColor = color;
	self.rightView.backgroundColor = color;
}

- (void)setStyle:(PanIndicatorViewStyle)style {
	_style = style;

	switch (style) {
		case PanIndicatorViewStyleLine:{
			[self animate:^{
				self.leftView.transform = CGAffineTransformIdentity;
				self.rightView.transform = CGAffineTransformIdentity;
			}];
		}
			break;
		case PanIndicatorViewStyleArrow: {
			CGFloat angle = 20 * M_PI / 180;
			[self animate:^{
				self.leftView.transform = CGAffineTransformMakeRotation(angle);
				self.rightView.transform = CGAffineTransformMakeRotation(-angle);
			}];
		}
			break;
	}
}


@end
