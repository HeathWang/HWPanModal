//
//  HWDimmedView.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWDimmedView.h"

@interface HWDimmedView ()

@property (nonatomic, assign) CGFloat dimAlpha;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation HWDimmedView

- (instancetype)initWithDimAlpha:(CGFloat)dimAlpha {
	self = [[HWDimmedView alloc] initWithFrame:CGRectZero];
	if (self) {
		_dimAlpha = dimAlpha;
	}

	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_dimAlpha = 0.7;
		_dimState = DimStateOff;
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0;

		_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
		[self addGestureRecognizer:_tapGestureRecognizer];
	}

	return self;
}

#pragma mark - touch action

- (void)didTapView {
	self.tapBlock ? self.tapBlock(self.tapGestureRecognizer) : nil;
}

#pragma mark - private method

- (void)updateAlpha {
	switch (self.dimState) {
		case DimStateMax:{
			self.alpha = self.dimAlpha;
		}
			break;
		case DimStateOff:{
			self.alpha = 0;
		}
			break;
		case DimStatePercent: {
			CGFloat value = MAX(0, MIN(1.0f, self.percent));
			self.alpha = self.dimAlpha * value;
		}
		default:
			break;
	}
}

#pragma mark - Setter

- (void)setDimState:(DimState)dimState {
	_dimState = dimState;
	[self updateAlpha];
}

- (void)setPercent:(CGFloat)percent {
	_percent = percent;
	[self updateAlpha];
}

@end
