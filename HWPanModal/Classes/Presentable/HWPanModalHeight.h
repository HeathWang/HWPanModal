//
//  HWPanModalHeight.h
//  Pods
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PanModalHeightType) {
    PanModalHeightTypeMax,  // 距离顶部最大
    PanModalHeightTypeMaxTopInset, // 距离顶部offset
    PanModalHeightTypeContent,
    PanModalHeightTypeContentIgnoringSafeArea,
    PanModalHeightTypeIntrinsic,
};

struct PanModalHeight {
    PanModalHeightType heightType;
    CGFloat height;
};

typedef struct PanModalHeight PanModalHeight;

CG_INLINE PanModalHeight PanModalHeightMake(PanModalHeightType heightType, CGFloat height) {
    PanModalHeight modalHeight;
    modalHeight.heightType = heightType;
    modalHeight.height = height;
    return modalHeight;
}

