//
//  HWStackedGroupViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWStackedGroupViewController.h"
#import "HWColorDetailViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface HWStackedGroupViewController () <HWPanModalPresentable>

@end

@implementation HWStackedGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [self colorWithIndex:indexPath.row];
    HWColorDetailViewController *controller = [HWColorDetailViewController new];
    controller.color = color;
    [self presentPanModal:controller];
}

#pragma mark - HWPanModalPresentable


- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

@end
