//
//  HWPanModal.h
//  Pods
//
//  Created by heath wang on 2019/4/30.
//
#import <Foundation/Foundation.h>

//! Project version number for HWPanModal.
FOUNDATION_EXPORT double HWPanModalVersionNumber;

//! Project version string for JYHitchModule.
FOUNDATION_EXPORT const unsigned char HWPanModalVersionString[];

// protocol
#import <HWPanModal/HWPanModalPresentable.h>
#import <HWPanModal/HWPanModalPanGestureDelegate.h>
#import <HWPanModal/HWPanModalHeight.h>

#import <HWPanModal/HWPanModalPresenterProtocol.h>

// category
#import <HWPanModal/UIViewController+PanModalDefault.h>
#import <HWPanModal/UIViewController+Presentation.h>
#import <HWPanModal/UIViewController+PanModalPresenter.h>

// custom animation
#import <HWPanModal/HWPresentingVCAnimatedTransitioning.h>

// view
#import <HWPanModal/HWPanModalIndicatorProtocol.h>
#import <HWPanModal/HWPanIndicatorView.h>
#import <HWPanModal/HWDimmedView.h>

// panModal view
#import <HWPanModal/HWPanModalContentView.h>
