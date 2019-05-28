//
//  HWDemoTypeModel.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWDemoTypeModel.h"
#import "HWBaseViewController.h"
#import "HWGroupViewController.h"
#import "HWAlertViewController.h"
#import "HWTransientAlertViewController.h"
#import "HWStackedGroupViewController.h"
#import "HWNavViewController.h"
#import "HWFullScreenNavController.h"
#import "HWPickerViewController.h"
#import "HWDynamicHeightViewController.h"
#import "HWShareViewController.h"
#import "HWAppListViewController.h"
#import "HWShoppingCartViewController.h"

@implementation HWDemoTypeModel

- (instancetype)initWithTitle:(NSString *)title targetClass:(Class)targetClass {
	self = [super init];
	if (self) {
		self.title = title;
		self.targetClass = targetClass;
	}

	return self;
}

+ (instancetype)modelWithTitle:(NSString *)title targetClass:(Class)targetClass {
	return [[self alloc] initWithTitle:title targetClass:targetClass];
}

+ (NSArray<HWDemoTypeModel *> *)demoTypeList {
	NSMutableArray *array = [NSMutableArray array];

	HWDemoTypeModel *baseDemo = [HWDemoTypeModel modelWithTitle:@"Basic" targetClass:HWBaseViewController.class];
	HWDemoTypeModel *groupDemo = [HWDemoTypeModel modelWithTitle:@"Group" targetClass:HWGroupViewController.class];
	HWDemoTypeModel *alertDemo = [HWDemoTypeModel modelWithTitle:@"Alert" targetClass:HWAlertViewController.class];
	HWDemoTypeModel *autoAlertDemo = [HWDemoTypeModel modelWithTitle:@"Transient Alert" targetClass:HWTransientAlertViewController.class];
	HWDemoTypeModel *stackGroupDemo = [HWDemoTypeModel modelWithTitle:@"Group - Stacked" targetClass:HWStackedGroupViewController.class];
	HWDemoTypeModel *fullScreenDemo = [HWDemoTypeModel modelWithTitle:@"Full Screen - Nav" targetClass:HWFullScreenNavController.class];
	HWDemoTypeModel *dynamicDemo = [HWDemoTypeModel modelWithTitle:@"Dynamic Height" targetClass:HWDynamicHeightViewController.class];
    HWDemoTypeModel *appDemo = [HWDemoTypeModel modelWithTitle:@"App Demo" targetClass:HWAppListViewController.class];

	[array addObjectsFromArray:@[appDemo, baseDemo, alertDemo, autoAlertDemo, dynamicDemo, groupDemo, stackGroupDemo, fullScreenDemo]];

	return [array copy];
}

+ (NSArray<HWDemoTypeModel *> *)appDemoTypeList {
    HWDemoTypeModel *navDemo = [HWDemoTypeModel modelWithTitle:@"Group - Nav - 知乎评论" targetClass:HWNavViewController.class];
    HWDemoTypeModel *pickerDemo = [HWDemoTypeModel modelWithTitle:@"Picker" targetClass:HWPickerViewController.class];
    HWDemoTypeModel *shareDemo = [HWDemoTypeModel modelWithTitle:@"Share - 网易云音乐" targetClass:HWShareViewController.class];
    HWDemoTypeModel *shoppingDemo = [HWDemoTypeModel modelWithTitle:@"Shopping - JD" targetClass:HWShoppingCartViewController.class];
    return @[navDemo, pickerDemo, shareDemo, shoppingDemo];
}

@end
