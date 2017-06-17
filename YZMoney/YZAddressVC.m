//
//  YZAddressVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZAddressVC.h"
#import "YZAdderssCell.h"
#import "YZEditorAddressVC.h"
#import "YZAddressModel.h"

@interface YZAddressVC ()<UITableViewDelegate, UITableViewDataSource, YZAdderssCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation YZAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.dataArray = [NSMutableArray array];
    self.navigationItem.title = @"地址管理";
    self.view.backgroundColor = YZ_GRAY_COLOR;
    [self.view addSubview:self.tableView];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(30, CGRectGetMaxY(self.tableView.frame) + 10, S_W - 60, 40);
    but.backgroundColor = YZ_RED_COLOR;
    [but setTitle:@"+新建收件信息" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font = MidFont;
    but.layer.cornerRadius = 4;
    but.layer.masksToBounds = YES;
    [self.view addSubview:but];
    [self request];
    WEAK_SELF;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf request];
    }];
}
- (void)request {
    WEAK_SELF;
    [YZHttpApiManager apiMineContractAddressListWithParameters:@{@"pageNum": @(self.currentPage)} completionHandler:^(id response, NSError *error) {
        if (response) {
            if ([response valueForKeyPath:@"data.addressData.result"]) {
                if (weakSelf.currentPage == 1) {
                    [weakSelf.dataArray removeAllObjects];
                }
                NSArray *array = [response valueForKeyPath:@"data.addressData.result"];
                for (NSDictionary *dic in array) {
                    YZAddressModel *model = [[YZAddressModel alloc]initWithDict:dic];
                
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tableView reloadData];
                NSInteger totalPage = [[response valueForKey:@"data.addressData.totalPage"] integerValue];
                [Utility tableViewFooterHiddenWith:weakSelf.tableView currentPage:weakSelf.currentPage totalPage:totalPage];
            }
        }
    } finished:^{
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H - 60)];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = YZ_GRAY_COLOR;
        [_tableView registerClass:[YZAdderssCell class] forCellReuseIdentifier:NSStringFromClass([YZAdderssCell class])];
    }
    return _tableView;
}
#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZAdderssCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZAdderssCell class])];
    cell.delegate = self;
    YZAddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.isDefault) {
        cell.defaultLbl.hidden = NO;
    }else {
        cell.defaultLbl.hidden = YES;
    }
    cell.editorBut.tag = indexPath.row;
    cell.nameLbl.text = model.receiveName;
    cell.phoneNumberLbl.text = model.receivePhone;
    cell.adderssLbl.text = [NSString stringWithFormat:@"%@%@", model.area, model.receiveAddress];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
//设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//左滑点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除事件
        YZAddressModel *model = self.dataArray[indexPath.row];
        WEAK_SELF;
        [YZHttpApiManager apiMineContractAddressRemoveWithParameters:@{@"id": model.ID} completionHandler:^(id response, NSError *error) {
            if ([response[@"code"] integerValue] == 0) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteBackWithModel:)]) {
                    [weakSelf.delegate deleteBackWithModel:model];
                }
                weakSelf.currentPage = 1;
                [weakSelf request];
            }
            
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZAddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOT_USEADDRESS_APPLY object:nil userInfo:@{@"addressModel": model}];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - customDelegate
- (void)editorPeopleAddressWithIndex:(NSInteger)index {
    YZEditorAddressVC *vc = [[YZEditorAddressVC alloc]init];
    vc.comeType = YZEditorAddressComeTypeEditor;
    vc.model = self.dataArray[index];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - action
- (void)addAction {
    YZEditorAddressVC *vc = [[YZEditorAddressVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
