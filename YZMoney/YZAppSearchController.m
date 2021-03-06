//
//  YZAppSearchController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/10.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZAppSearchController.h"
#import "YZOrderCell.h"
#import "YZAppointModel.h"
#import "YZMineAppointDetailVC.h"
#import "SearchHisModel.h"

@interface YZAppSearchController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SearchHisViewDelegate>
@property (nonatomic, strong)NSMutableArray *arrAppoint;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation YZAppSearchController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchNavView.textField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.searchView.comeType = ComeTypeWithSearchOrder;
    self.arrAppoint = [NSMutableArray array];

    self.searchView.delegate = self;
    self.searchNavView.textField.placeholder = @"搜索产品名称/订单号";
    self.searchNavView.textField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[YZOrderCell class] forCellReuseIdentifier:NSStringFromClass([YZOrderCell class])];
    [self.searchNavView.backBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchNavView.searchBut addTarget:self action:@selector(searchButAction) forControlEvents:UIControlEventTouchUpInside];
    WEAK_SELF;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf searchRequest:self.searchNavView.textField.text];
    }];
}
#pragma mark - request
- (void)searchRequest:(NSString * _Nonnull)searchText {
    self.searchView.hidden = YES;
    WEAK_SELF;
    [YZHttpApiManager apiMineAppointSearchWithParameters:@{@"keywords" : searchText, @"pageNum": @(self.currentPage)}
completionHandler:^(id response, NSError *error) {
    [weakSelf.tableView.mj_header endRefreshing];
    
    [YZViewManager viewManagerWithTextAndView:weakSelf.tableView
                                  data:[response valueForKeyPath:@"data.pageResult.result"]
                                        error:error withText:@"您还没有该产品下的订单"
                                 block:^{
                                     if (weakSelf.currentPage == 1) {
                                         [_arrAppoint removeAllObjects];
                                     }
                                     for (NSDictionary *dic in [response valueForKeyPath:@"data.pageResult.result"]) {
                                         [_arrAppoint addObject:[[YZAppointModel alloc] initWithDict:dic]];
                                     }
                                     
                                     [weakSelf.tableView reloadData];
                                     [Utility tableViewFooterHiddenWith:weakSelf.tableView currentPage:weakSelf.currentPage totalPage:[[response valueForKeyPath:@"data.pageResult.totalPage"] integerValue]];
                                 }];
    } finished:^{
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - textFieldDelegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 0) {
        [self searchRequest:toBeString];
    } else {
        self.searchView.hidden = false;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchButAction];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchView.hidden = NO;
    return YES;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrAppoint.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZOrderCell class])];
    YZAppointModel *appoint = _arrAppoint[indexPath.row];
    [cell sendWithYZAppModel:appoint];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchNavView.textField resignFirstResponder];
    YZAppointModel *appoint = _arrAppoint[indexPath.row];
    YZMineAppointDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"apppoint_detail_vc"];
    [vc setAppoint:appoint];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - customDelegate
- (void)historySearchAction:(SearchHisModel *)text isLabel:(BOOL)isLabel{
    self.searchNavView.textField.text = text.searchText;
    [self.searchNavView.textField resignFirstResponder];
    [self searchRequest:self.searchNavView.textField.text];
}
#pragma mark - action
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchButAction {
    [self.searchNavView.textField resignFirstResponder];
    if (self.searchNavView.textField.text.length) {
        [self searchRequest:self.searchNavView.textField.text];
        [self.searchView searchUitls:self.searchNavView.textField.text];
    }else{
        self.searchView.hidden = NO;
    }
}
@end
