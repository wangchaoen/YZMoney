//
//  YZConntractSearchVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/27.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZConntractSearchVC.h"
#import "YZContractCell.h"

@interface YZConntractSearchVC ()<UITableViewDelegate, UITableViewDataSource, YZContractCellDelegate>

@end

@implementation YZConntractSearchVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchView.comeType = ComeTypeWithSearchOrder;
//    self.searchView.delegate = self;
    self.searchNavView.textField.placeholder = @"搜索合同名称";
    [self.searchNavView.backBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchNavView.searchBut addTarget:self action:@selector(searchButAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZContractCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZContractCell class])];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
#pragma mark - customDelegate
- (void)butClickActionWithCell:(YZContractCell *)cell but:(UIButton *)but {
    
}
#pragma mark - action
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchButAction {
    
}



@end
