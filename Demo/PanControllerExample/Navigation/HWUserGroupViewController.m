//
//  HWUserGroupViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWUserGroupViewController.h"
#import "HWColorDetailViewController.h"

@interface HWUserGroupViewController ()

@end

@implementation HWUserGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"COLOR LIST";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [self colorWithIndex:indexPath.row];
    HWColorDetailViewController *controller = [HWColorDetailViewController new];
    controller.color = color;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
