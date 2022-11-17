//
//  HWEventPassThroughViewController.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/9/27.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWEventPassThroughViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/Masonry.h>

@interface HWEventPassThroughViewController () <HWPanModalPresentable>


@end

@implementation HWEventPassThroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.000 blue:0.800 alpha:1.00];
    
    
    UILabel *label = [UILabel new];
    label.text = @"You can try to tap/pan/rotate/pin the view that beyond the blue view.\n As you see, the event can pass through.";
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.centerY.equalTo(@0);
    }];
}

#pragma mark - HWMapViewControllerDelegate

- (void)userMoveMapView:(HWMapViewController *)mapViewController {
    [self hw_panModalTransitionTo:PresentationStateShort];
}

- (void)didRelease:(HWMapViewController *)mapController {
    [self hw_dismissAnimated:YES completion:NULL];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 220);
}

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 49);
}

- (PresentationState)originPresentationState {
    return PresentationStateLong;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView {
    return YES;
}

- (void)willTransitionToState:(PresentationState)state {
    switch (state) {
        case PresentationStateLong:
            self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.000 blue:0.800 alpha:1.00];
            break;
            
        default:
            self.view.backgroundColor = [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.00];
            break;
    }
}

@end
