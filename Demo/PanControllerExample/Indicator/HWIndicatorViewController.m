//
//  HWIndicatorViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "HWIndicatorViewController.h"
#import "HWIndicatorPopViewController.h"
#import <Masonry/Masonry.h>
#import <HWPanModal/HWPanModal.h>

@interface HWIndicatorModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) HWIndicatorStyle style;

- (instancetype)initWithTitle:(NSString *)title style:(HWIndicatorStyle)style;

+ (instancetype)modelWithTitle:(NSString *)title style:(HWIndicatorStyle)style;

@end

@interface HWIndicatorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *styleList;

@end

@implementation HWIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Custom Indicator";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.styleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    HWIndicatorModel *indicatorModel = self.styleList[(NSUInteger) indexPath.row];
    cell.textLabel.text = indicatorModel.title;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWIndicatorModel *indicatorModel = self.styleList[(NSUInteger) indexPath.row];
    HWIndicatorPopViewController *popViewController = [HWIndicatorPopViewController controllerWithIndicatorStyle:indicatorModel.style];
    [self presentPanModal:popViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.rowHeight = 60;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)styleList {
    if (!_styleList) {
        HWIndicatorModel *modelColor = [HWIndicatorModel modelWithTitle:@"Custom Default Indicator Color" style:HWIndicatorStyleChangeColor];
        HWIndicatorModel *modelText = [HWIndicatorModel modelWithTitle:@"A Text Indicator View" style:HWIndicatorStyleText];
        HWIndicatorModel *modelView = [HWIndicatorModel modelWithTitle:@"Immobile Indicator View" style:HWIndicatorStyleImmobile];
        _styleList = @[modelColor, modelText, modelView];
    }
    return _styleList;
}


@end

@implementation HWIndicatorModel

- (instancetype)initWithTitle:(NSString *)title style:(HWIndicatorStyle)style {
    self = [super init];
    if (self) {
        _title = [title copy];
        _style = style;
    }

    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title style:(HWIndicatorStyle)style {
    return [[self alloc] initWithTitle:title style:style];
}


@end
