//
//  InstitutionController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/24.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "InstitutionController.h"
#import "HomeProductCell.h"
#import "YZProductModel.h"
#import "YZProductDetailVC.h"

@interface InstitutionController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *columnUrl;
@end

@implementation InstitutionController
- (instancetype)initWithTitle:(NSString *)title companyId:(NSString *)companyId columnUrl:(NSString *)columnUrl{
    self = [super init];
    if (self) {
        self.title = title;
        self.companyId = companyId;
        self.columnUrl = columnUrl;
        self.array = [NSMutableArray array];
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 64)];
    head.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:head];
    WEAK_SELF;
    [Utility MJRefreshHeaderGif:self.tableView headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf requestWithInstitution];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestWithInstitution];
    }];
    [self requestWithInstitution];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - request
- (void)requestWithInstitution {
    WEAK_SELF;
    [YZHttpApiManager apiSearchCategorySearchCompanyWithParameters:@{@"companyId": self.companyId, @"pageNum": @(self.currentPage), @"columnUrl": self.columnUrl} completionHandler:^(id response, NSError *error) {
        [weakSelf requestUtilsWithResponse:response error:error];
            } finished:^{
                
            }];
}
- (void)requestUtilsWithResponse:(id)response error:(NSError *)error{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (!response) {
        return;
    }
    NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
    NSArray * dataArr = productResult[@"result"];
    WEAK_SELF;
    [YZViewManager viewManagerWithView:weakSelf.tableView data:dataArr error:error block:^{
        if (weakSelf.currentPage == 1) {
            [weakSelf.array removeAllObjects];
        }
        NSArray *array = [YZProductModel jsonWithData:response];
        for (YZProductModel *model in array) {
            [weakSelf.array addObject:model];
        }
        
        [weakSelf.tableView reloadData];
        if ([productResult[@"totalPage"] integerValue] == weakSelf.currentPage) {
            [weakSelf.tableView.mj_footer  endRefreshingWithNoMoreData];
        }else {
            weakSelf.currentPage += 1;
            weakSelf.tableView.mj_footer.hidden = false;
        }
    }];

}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H)];
        _tableView.backgroundColor = YZ_GRAY_COLOR;
        [_tableView registerClass:[HomeProductCell class] forCellReuseIdentifier:NSStringFromClass([HomeProductCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductCell class])];
    YZProductModel *model = self.array[indexPath.row];
    [cell sendModelViewIndexWith:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
    YZProductModel *model = self.array[indexPath.row];
    if (model.detailCheckLogin && !ISLOGIN) {
        [Utility goLogin];
        return;
    }
    productVC.idProduct = model.ID;
    productVC.column = model.column;
    [self.navigationController pushViewController:productVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductModel *model = self.array[indexPath.row];
    return [HomeProductCell returnRowsHeightWith:model];
}
@end
