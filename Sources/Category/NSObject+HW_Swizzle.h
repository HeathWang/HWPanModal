//
//  NSObject+HW_Swizzle.h
//  HWPanModal
//
//  Created by heath wang on 2019/8/16.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HW_Swizzle)

+ (BOOL)hw_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)hw_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

@end

NS_ASSUME_NONNULL_END
