//
//  HWBaseViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/4/30.
//  Copyright © 2019 HeathWang. All rights reserved.
//

#import <HWPanModal/HWPanModal.h>
#import "HWBaseViewController.h"

@interface HWBaseViewController () <HWPanModalPresentable, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;

@end

@implementation HWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.000 green:0.989 blue:0.935 alpha:1.00];
    
    self.textfield = [UITextField new];
    self.textfield.borderStyle = UITextBorderStyleBezel;
    self.textfield.frame = CGRectMake(20, 64, 300, 38);
    self.textfield.placeholder = @"Please type something.";
    self.textfield.delegate = self;
    [self.view addSubview:self.textfield];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 200.00001);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500.00001);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (CGFloat)topOffset {
    return self.topLayoutOffset;
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (HWPanModalShadow)contentShadow {
    return PanModalShadowMake([UIColor yellowColor], 10, CGSizeMake(0, 2), 1);
}

//- (UIViewAnimationOptions)transitionAnimationOptions {
//    return UIViewAnimationOptionCurveLinear;
//}

- (BOOL)showDragIndicator {
    return NO;
}

#ifdef DEBUG

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#endif


@end
