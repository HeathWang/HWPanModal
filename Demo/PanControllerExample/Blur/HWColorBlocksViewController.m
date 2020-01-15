//
//  HWColorBlocksViewController.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/6/14.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HWColorBlocksViewController.h"
#import "HWColorCollectionViewCell.h"
#import <HWPanModal/HWPanModal.h>
#import "HWBlurViewController.h"
#import "UIColor+HW.h"

@interface HWColorBlocksViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<UIColor *> *colors;

@end

@implementation HWColorBlocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Color Blocks";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.view addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

}

- (void)addAction {
    if (!self.presentedViewController) {
        [self presentPanModal:[HWBlurViewController new]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HWColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HWColorCollectionViewCell.class) forIndexPath:indexPath];
    cell.bgColor = self.colors[indexPath.row];
    return cell;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        flowLayout.itemSize = CGSizeMake((screenSize.width - 20) / 2, 88);
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.minimumLineSpacing = 20;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:HWColorCollectionViewCell.class  forCellWithReuseIdentifier:NSStringFromClass(HWColorCollectionViewCell.class)];
        _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSArray<UIColor *> *)colors {
    if (!_colors) {
        NSMutableArray<UIColor *> *tmp = [NSMutableArray arrayWithCapacity:20];
        for (int i = 0; i < 20; ++i) {
            UIColor *color = [UIColor hw_randomColor];
            [tmp addObject:color];
        }

        _colors = [tmp copy];
    }
    return _colors;
}

@end
