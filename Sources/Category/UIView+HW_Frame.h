//
//  UIView+HW_Frame.h
//  HWPanModal
//
//  Created by heath wang on 2019/5/20.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HW_Frame)

@property (nonatomic, assign) CGFloat hw_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat hw_top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat hw_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat hw_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat hw_width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat hw_height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat hw_centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat hw_centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint hw_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  hw_size;        ///< Shortcut for frame.size.

@end

NS_ASSUME_NONNULL_END
