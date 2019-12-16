//
//  HWPanModalNavView.h
//  HWPanModalDemo
//
//  Created by heath wang on 2019/12/16.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HWPanModalNavViewDelegate <NSObject>

@optional
- (void)didTapBackButton;

- (void)didTapRightButton;

@end

@interface HWPanModalNavView : UIView

@property (nonatomic, assign) CGFloat statusBarHeight;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rightButtonTitle;
@property (nullable, nonatomic, copy) NSString *backButtonTitle;

@property (nonatomic, weak) id<HWPanModalNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
