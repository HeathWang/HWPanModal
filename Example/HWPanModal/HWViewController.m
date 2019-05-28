//
//  HWViewController.m
//  HWPanModal
//
//  Created by HeathWang on 05/05/2019.
//  Copyright (c) 2019 HeathWang. All rights reserved.
//

#import "HWViewController.h"
#import "HWDemoTypeModel.h"
#import <HWPanModal/HWPanModal.h>
#import <Masonry/Masonry.h>
#import "HWAppListViewController.h"

@interface HWViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Example";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];

    HWDemoTypeModel *demoTypeModel = self.demoList[indexPath.row];
    cell.textLabel.text = demoTypeModel.title;
    if ([NSStringFromClass(demoTypeModel.targetClass) isEqualToString:NSStringFromClass(HWAppListViewController.class)]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	HWDemoTypeModel *demoTypeModel = self.demoList[indexPath.row];
    if ([NSStringFromClass(demoTypeModel.targetClass) isEqualToString:NSStringFromClass(HWAppListViewController.class)]) {
        [self.navigationController pushViewController:[HWAppListViewController new] animated:YES];
    } else {
        [self presentPanModal:[[demoTypeModel.targetClass alloc] init]];
    }
    
}

#pragma mark - Getter

- (NSArray *)demoList {
	if (!_demoList) {
		_demoList = [HWDemoTypeModel demoTypeList];
	}
	return _demoList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.rowHeight = 60;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
