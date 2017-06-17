//
//  YZHotProductVC.m
//  YZMoney
//
//  Created by 7仔 on 16/6/13.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "YZHotProductVC.h"
#import "YZProductModel.h"
#import "YZProductDetailVC.h"
#import "HomeProductCell.h"




@interface YZHotProductVC ()

@property (nonatomic, strong) NSMutableArray *arrProduct;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage;
@end





@implementation YZHotProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.arrProduct = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
    self.tableView.backgroundColor = YZ_GRAY_COLOR;
    [self.tableView registerClass:[HomeProductCell class] forCellReuseIdentifier:NSStringFromClass([HomeProductCell class])];
    WEAK_SELF;
    [Utility MJRefreshHeaderGif:self.tableView headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    WEAK_SELF;
    [YZHttpApiManager apiHotProductWithParameters:@{@"pageNum": @(self.currentPage), @"columnUrl": @"hot"}
                                completionHandler:^(id response, NSError *error) {
                                    [weakSelf.tableView.mj_header endRefreshing];
                                    [weakSelf.tableView.mj_footer endRefreshing];
                                    if (![response[@"success"] boolValue]) {
                                        return;
                                    }
                                    if (weakSelf.currentPage == 1) {
                                        [weakSelf.arrProduct removeAllObjects];
                                    }
                                    NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
//                                    NSArray * dataArr = productResult[@"result"];

                                    NSArray *array = [YZProductModel jsonWithData:response];
                                    for (YZProductModel *model in array) {
                                        [weakSelf.arrProduct addObject:model];
                                    }
                                    [self.tableView reloadData];
                                    
                                    self.totalPage = [productResult [@"totalPage"] integerValue];
                                    [Utility tableViewFooterHiddenWith:weakSelf.tableView currentPage:weakSelf.currentPage totalPage:weakSelf.totalPage];
                                }];
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrProduct.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HomeProductCell returnRowsHeightWith:_arrProduct[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    YZProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_product"];
//    if (!cell) {
//        cell = [[YZProductCell alloc] init];
//    }
    HomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductCell class])];
    [cell sendModelViewIndexWith:_arrProduct[indexPath.row]];
//    [cell configureCellWithProduct:_arrProduct[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductModel *model = _arrProduct[indexPath.row];
    if (model.detailCheckLogin && !ISLOGIN) {
        [APPDELEGATE.window.rootViewController performSegueWithIdentifier:@"segue_tab_login" sender:nil];
    }
    else {
        [self performSegueWithIdentifier:@"segue_hot_product" sender: model];
    }
}


#pragma mark - scroll view

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_hot_product"]) {
        [(YZProductDetailVC *)segue.destinationViewController setIdProduct:[sender ID]];
        [(YZProductDetailVC *)segue.destinationViewController setColumn:[sender column]];
    }
}

@end
