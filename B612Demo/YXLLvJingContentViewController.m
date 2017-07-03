//
//  YXLLvJingContentViewController.m
//  B612Demo
//
//  Created by yingxl1992 on 2017/6/28.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLLvJingContentViewController.h"



@interface YXLLvJingContentViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *filterNames;

@end

@implementation YXLLvJingContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FilterTypes"
                                                         ofType:@"plist"];
    self.filterNames = [NSArray arrayWithContentsOfFile:filePath];
    
    [self.mainCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(60, 40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:flowLayout];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    [self.mainCollectionView registerClass:[UICollectionViewCell class]
                forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_filterNames count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.text = [_filterNames[indexPath.row] objectForKey:@"key"];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.centerY.equalTo(cell.mas_centerY);
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(lvJingContentViewControllerChangeFilterType:)]) {
        
        [self.delegate lvJingContentViewControllerChangeFilterType:[[_filterNames objectAtIndex:indexPath.row] objectForKey:@"value"]];
    }
}

@end
