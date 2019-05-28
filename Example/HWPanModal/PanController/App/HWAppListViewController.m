//
//  HWAppListViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/28.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWAppListViewController.h"
#import "HWDemoTypeModel.h"

@interface HWAppListViewController ()

@end

@implementation HWAppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.demoList = [HWDemoTypeModel appDemoTypeList];
    self.navigationItem.title = @"App UI";
}

@end
