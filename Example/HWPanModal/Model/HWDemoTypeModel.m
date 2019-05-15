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
	HWDemoTypeModel *navDemo = [HWDemoTypeModel modelWithTitle:@"Group - Nav" targetClass:HWNavViewController.class];
	HWDemoTypeModel *fullScreenDemo = [HWDemoTypeModel modelWithTitle:@"Full Screen - Nav" targetClass:HWFullScreenNavController.class];

	[array addObjectsFromArray:@[baseDemo, alertDemo, autoAlertDemo, groupDemo, stackGroupDemo, navDemo, fullScreenDemo]];

	return [array copy];
}

@end
