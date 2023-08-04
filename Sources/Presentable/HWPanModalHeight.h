//
//  HWPanModalHeight.h
//  Pods
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PanModalHeightType) {
    PanModalHeightTypeMax NS_SWIFT_NAME(max), // from top max
    PanModalHeightTypeMaxTopInset NS_SWIFT_NAME(topInset), // from top offset
    PanModalHeightTypeContent NS_SWIFT_NAME(content), // from bottom
    PanModalHeightTypeContentIgnoringSafeArea NS_SWIFT_NAME(contentIgnoringSafeArea), // from bottom ignore safeArea
    PanModalHeightTypeIntrinsic NS_SWIFT_NAME(intrinsic), // auto get size, There is something wrong, DO NOT recommend to use.
};

struct PanModalHeight {
    PanModalHeightType heightType NS_SWIFT_NAME(type);
    CGFloat height;
};

typedef struct PanModalHeight PanModalHeight;

/**
 * When heightType is PanModalHeightTypeMax, PanModalHeightTypeIntrinsic, the height value will be ignored.
 */
CG_INLINE PanModalHeight PanModalHeightMake(PanModalHeightType heightType, CGFloat height) {
    PanModalHeight modalHeight;
    modalHeight.heightType = heightType;
    modalHeight.height = height;
    return modalHeight;
}

static inline BOOL HW_FLOAT_IS_ZERO(CGFloat value) {
    return (value > -FLT_EPSILON) && (value < FLT_EPSILON);
}

static inline BOOL HW_TWO_FLOAT_IS_EQUAL(CGFloat x, CGFloat y) {
    CGFloat minusValue = fabs(x - y);
    CGFloat criticalValue = 0.0001;
    if (minusValue < criticalValue || minusValue < FLT_MIN) {
        return YES;
    }
    return NO;
}

