//
//  HWPanModalHeight.h
//  Pods
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PanModalHeightType) {
    PanModalHeightTypeMax,          // from top max
    PanModalHeightTypeMaxTopInset,  // from top offset
    PanModalHeightTypeContent,      // from bottom
    PanModalHeightTypeContentIgnoringSafeArea,
    PanModalHeightTypeIntrinsic,
};

struct PanModalHeight {
    PanModalHeightType heightType;
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

