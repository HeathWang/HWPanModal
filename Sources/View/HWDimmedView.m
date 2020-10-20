//
//  HWDimmedView.m
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "HWDimmedView.h"
#import "HWVisualEffectView.h"
#import "HWBackgroundConfig.h"

@interface HWDimmedView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) HWVisualEffectView *blurView;
@property (nonatomic, strong) HWBackgroundConfig *backgroundConfig;

@property (nonatomic, assign) CGFloat maxDimAlpha;
@property (nonatomic, assign) CGFloat maxBlurRadius;
@property (nonatomic, assign) CGFloat maxBlurTintAlpha;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL isBlurMode;

@end

@implementation HWDimmedView

- (instancetype)initWithDimAlpha:(CGFloat)dimAlpha blurRadius:(CGFloat)blurRadius {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		_maxBlurRadius = blurRadius;
		_maxDimAlpha = dimAlpha;
        [self commonInit];
    }

	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_maxDimAlpha = 0.7;
        [self commonInit];
    }

	return self;
}

- (instancetype)initWithBackgroundConfig:(HWBackgroundConfig *)backgroundConfig {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.backgroundConfig = backgroundConfig;
		_maxDimAlpha = backgroundConfig.backgroundAlpha;
		_maxBlurRadius = backgroundConfig.backgroundBlurRadius;
		_blurTintColor = backgroundConfig.blurTintColor;

		[self commonInit];
	}

	return self;
}

- (void)commonInit {
    _dimState = DimStateOff;
    _maxBlurTintAlpha = 0.5;
    // default, max alpha.
    _percent = 1;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    [self addGestureRecognizer:_tapGestureRecognizer];

    [self setupView];
}

- (void)setupView {
	self.isBlurMode = self.maxBlurRadius > 0 || self.backgroundConfig.visualEffect;
	if (self.isBlurMode) {
		[self addSubview:self.blurView];
        [self configBlurView];
	} else {
		[self addSubview:self.backgroundView];
	}
}

#pragma mark - layout

- (void)layoutSubviews {
	[super layoutSubviews];

	// not call getter.
	_blurView.frame = self.bounds;
	_backgroundView.frame = self.bounds;
}

#pragma mark - touch action

- (void)didTapView {
	self.tapBlock ? self.tapBlock(self.tapGestureRecognizer) : nil;
}

#pragma mark - public method

- (void)reloadConfig:(HWBackgroundConfig *)backgroundConfig {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.backgroundConfig = backgroundConfig;
    _maxDimAlpha = backgroundConfig.backgroundAlpha;
    _maxBlurRadius = backgroundConfig.backgroundBlurRadius;
    _blurTintColor = backgroundConfig.blurTintColor;

    [self setupView];
    
    DimState state = self.dimState;
    self.dimState = state;
}

#pragma mark - private method

- (void)updateAlpha {
	CGFloat alpha = 0;
	CGFloat blurRadius = 0;
	CGFloat blurTintAlpha = 0;

	switch (self.dimState) {
		case DimStateMax:{
			alpha = self.maxDimAlpha;
			blurRadius = self.maxBlurRadius;
            blurTintAlpha = self.maxBlurTintAlpha;
		}
			break;
		case DimStatePercent: {
			CGFloat percent = MAX(0, MIN(1.0f, self.percent));
			alpha = self.maxDimAlpha * percent;
			blurRadius = self.maxBlurRadius * percent;
            blurTintAlpha = self.maxBlurTintAlpha * percent;
		}
		default:
			break;
	}

	if (self.isBlurMode) {
		if (self.backgroundConfig.visualEffect) return;

		self.blurView.blurRadius = blurRadius;
		self.blurView.colorTintAlpha = blurTintAlpha;
	} else {
		self.backgroundView.alpha = alpha;
	}
}

- (void)configBlurView {
    if (self.backgroundConfig.visualEffect) {
        [_blurView updateBlurEffect:self.backgroundConfig.visualEffect];
    } else {
        _blurView.colorTint = [UIColor whiteColor];
        _blurView.colorTintAlpha = self.maxBlurTintAlpha;
        _blurView.userInteractionEnabled = NO;
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

#pragma mark - Getter

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [UIView new];
		_backgroundView.userInteractionEnabled = NO;
		_backgroundView.alpha = 0;
		_backgroundView.backgroundColor = [UIColor blackColor];
	}
	return _backgroundView;
}

- (HWVisualEffectView *)blurView {
	if (!_blurView) {
		_blurView = [HWVisualEffectView new];
	}
	return _blurView;
}

#pragma mark - Setter

- (void)setBlurTintColor:(UIColor *)blurTintColor {
    _blurTintColor = blurTintColor;
    _blurView.colorTint = _blurTintColor;
}


@end
