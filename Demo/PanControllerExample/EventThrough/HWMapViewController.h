//
//  HWMapViewController.h
//  HWPanModalDemo
//
//  Created by heath wang on 2019/9/27.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWMapViewController;

@protocol HWMapViewControllerDelegate <NSObject>

- (void)userMoveMapView:(HWMapViewController *_Nonnull)mapViewController;

- (void)didRelease:(HWMapViewController *_Nonnull)mapController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HWMapViewController : UIViewController

@property (nonatomic, weak) id <HWMapViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
