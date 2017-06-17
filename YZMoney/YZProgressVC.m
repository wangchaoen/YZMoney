//
//  YZProgressVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZProgressVC.h"
#import "YZProgressCell.h"
#import "YZProgressModel.h"

@interface YZProgressVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YZProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.navigationItem.title = @"当前进度";
    self.view.backgroundColor = YZ_GRAY_COLOR;
    [self.view addSubview:self.tableView];
    WEAK_SELF;
    [YZHttpApiManager apiMineContractLookProgressWithParameters:@{@"id": self.applyCompactId} completionHandler:^(id response, NSError *error) {
        NSArray *array = response[@"data"];
        for (NSDictionary *dic in array) {
            YZProgressModel *model = [[YZProgressModel alloc]init];
            [model modelFromJson:dic];
            [weakSelf.dataArray addObject:model];
        }
        [weakSelf.tableView reloadData];
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 5, S_W - 30, S_H - 5)];
        _tableView.backgroundColor = YZ_GRAY_COLOR;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YZProgressCell class] forCellReuseIdentifier:NSStringFromClass([YZProgressCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZProgressCell class])];
    YZProgressModel *model = self.dataArray[indexPath.row];
    [cell sendWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProgressModel *model = self.dataArray[indexPath.row];
    return [YZProgressCell returnRowsHeightWithModel:model];
}
@end
