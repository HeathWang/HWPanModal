//
//  HWViewController.m
//  HWPanModal
//
//  Created by wangcongling on 05/05/2019.
//  Copyright (c) 2019 wangcongling. All rights reserved.
//

#import "HWViewController.h"
#import "HWGroupViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface HWViewController ()

@end

@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"基本测试" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTapToTest) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setFrame:CGRectMake(15, 84, 80, 40)];
}

- (void)didTapToTest {
    [self presentPanModal:[HWGroupViewController new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
