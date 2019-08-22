//
//  HWAlertView.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HWAlertView.h"

@implementation HWAlertView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithRed:0.972 green:0.969 blue:0.836 alpha:1.00];
		UILabel *label = [UILabel new];
		label.text = @"THIS IS AN ERROR!";
		label.font = [UIFont systemFontOfSize:16];
		label.textColor = [UIColor redColor];
		label.textAlignment = NSTextAlignmentCenter;

		[self addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.mas_equalTo(CGPointZero);
		}];
	}

	return self;
}




@end
