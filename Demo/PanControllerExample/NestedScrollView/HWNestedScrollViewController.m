//
//  HWNestedScrollViewController.m
//  HWPanModalDemo
//
//  Created by heath wang on 2020/5/21.
//  Copyright © 2020 wangcongling. All rights reserved.
//

#import "HWNestedScrollViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "HWColorCell.h"
#import "UIColor+HW.h"
#import <Masonry/Masonry.h>

@interface HWNestedScrollViewController () <HWPanModalPresentable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic, strong) NSArray *colorArray1;
@property (nonatomic, strong) NSArray *colorArray2;

@end

@implementation HWNestedScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareData];

    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.tableView1];
    [self.scrollView addSubview:self.tableView2];

    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
    }];

    [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView1.mas_right);
        make.top.right.equalTo(@0);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

}

- (void)prepareData {
    NSMutableArray *list1 = [NSMutableArray arrayWithCapacity:30];
    NSMutableArray *list2 = [NSMutableArray arrayWithCapacity:10];

    for (int i = 0; i < 40; ++i) {
        [list1 addObject:[UIColor hw_randomColor]];
    }

    for (int j = 0; j < 12; ++j) {
        [list2 addObject:[UIColor hw_randomColor]];
    }

    self.colorArray1 = [list1 copy];
    self.colorArray2 = [list2 copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (tableView == self.tableView1) {
        return self.colorArray1.count;
    } else {
        return self.colorArray2.count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWColorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HWColorCell.class) forIndexPath:indexPath];
    if (tableView == self.tableView1) {
        cell.backgroundColor = self.colorArray1[indexPath.row];
    } else {
        cell.backgroundColor = self.colorArray2[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView1) {
        return 55;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - HWPanModalPresentable

- (BOOL)showDragIndicator {
    return NO;
}

- (UIScrollView *)panScrollable {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        return self.tableView1;
    } else {
        return self.tableView2;
    }

}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 66);
}

#pragma mark - touch action

- (void)changeMenuIndex {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) * index, 0) animated:YES];

    [self hw_panModalSetNeedsLayoutUpdate];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B"]];
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(changeMenuIndex) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UITableView *)createTable {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [tableView registerClass:HWColorCell.class forCellReuseIdentifier:NSStringFromClass(HWColorCell.class)];
    
    return tableView;
}

- (UITableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [self createTable];
    }
    return _tableView1;
}

- (UITableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [self createTable];
    }
    return _tableView2;
}

@end
