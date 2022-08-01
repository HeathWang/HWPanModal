//
//  HWPanModalPanGestureDelegate.h
//  Pods
//
//  Created by heath wang on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  In this framewok, we use UIPanGestureRecognizer to control user drags behavior.
 *  The internal logic, there are two panGestureRecognizers delegate will response below delegate: the main panGesture used to control darg down, another panGesture used to control screen edge dismiss.
 *  Implement this delegate and custom user drag behavior.
 *  WARNING: BE CAREFUL, AND KNOW WHAT YOU ARE DOING!
 */
@protocol HWPanModalPanGestureDelegate <NSObject>

- (BOOL)hw_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)hw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (BOOL)hw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
- (BOOL)hw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;


@end

NS_ASSUME_NONNULL_END

