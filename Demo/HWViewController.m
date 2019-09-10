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

@interface HWViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Objective-C Example";
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
    cell.accessoryType = demoTypeModel.action == HWActionTypePush ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	HWDemoTypeModel *demoTypeModel = self.demoList[indexPath.row];
    
    if (demoTypeModel.action == HWActionTypePush) {
        [self.navigationController pushViewController:[demoTypeModel.targetClass new] animated:YES];
    } else {
        [self presentPanModal:[[demoTypeModel.targetClass alloc] init] completion:^{
            
        }];
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
        _tableView.rowHeight = 44;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
