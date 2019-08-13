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
    PanModalHeightTypeIntrinsic NS_SWIFT_NAME(intrinsic),
};

struct PanModalHeight {
    PanModalHeightType heightType NS_SWIFT_NAME(type);
    CGFloat height;
};

typedef struct PanModalHeight PanModalHeight;

/**
 * When heightType is PanModalHeightTypeMax, PanModalHeightTypeIntrinsic, the height value will be ignored.
 */
CG_INLINE PanModalHeight PanModalHeightMake(PanModalHeightType heightType, CGFloat height) NS_SWIFT_NAME(PanModalHeight(type:height)) {
    PanModalHeight modalHeight;
    modalHeight.heightType = heightType;
    modalHeight.height = height;
    return modalHeight;
}

static inline BOOL HW_FLOAT_IS_ZERO(CGFloat value) {
    return (value > -FLT_EPSILON) && (value < FLT_EPSILON);
}

