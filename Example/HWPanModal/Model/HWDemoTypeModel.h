//
//  HWDemoTypeModel.h
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWDemoTypeModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) Class targetClass;

- (instancetype)initWithTitle:(NSString *)title targetClass:(Class)targetClass;

+ (instancetype)modelWithTitle:(NSString *)title targetClass:(Class)targetClass;


+ (NSArray<HWDemoTypeModel *> *)demoTypeList;
+ (NSArray<HWDemoTypeModel *> *)appDemoTypeList;

@end

NS_ASSUME_NONNULL_END
