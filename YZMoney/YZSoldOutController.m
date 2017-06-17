//
//  YZSoldOutController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/13.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZSoldOutController.h"
#import "YZSoldOutCell.h"
//#import "YZSearchProductModel.h"
#import "YZProductModel.h"
#import "YZProductDetailVC.h"
#import "HomeProductCell.h"

@interface YZSoldOutController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) SoldOutComeType comeType;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageCurrent;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger pageTotal;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YZSoldOutController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserHasGet object:nil];
}
- (instancetype)initWithTitle:(NSString *)title comeType:(SoldOutComeType)type
{
    self = [super init];
    if (self) {
        self.searchText = title;
        self.comeType = type;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.comeType = SoldOutComeTypeIndexSearch;
    }
    return self;
}
- (void)userHasGet {
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasGet) name:kUserHasGet object:nil];

    self.dataArray = [NSMutableArray array];
//    if (self.comeType == SoldOutComeTypeLabel) {
        self.title = self.searchText;
//    }else{
//        self.navigationItem.title = @"售罄产品";
//    }
    
    [self.view addSubview:self.tableView];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 64)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    self.pageCurrent = 1;
    if (self.searchText) {
        [self request];
    }
    WEAK_SELF;
    [Utility MJRefreshHeaderGif:self.tableView headerWithRefreshingBlock:^{
        weakSelf.pageCurrent = 1;
        [weakSelf request];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageCurrent++;
        [weakSelf request];
    }];
    weakSelf.tableView.mj_footer.hidden = YES;
}
- (void)request {
    WEAK_SELF;
    if (self.comeType == SoldOutComeTypeLabel) {
        [YZHttpApiManager apiSearchCategorySearchLabelWithParameters:@{@"queryText": self.searchText, @"pageNum": @(self.pageCurrent), @"soldOut": @1} completionHandler:^(id response, NSError *error){
            NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
            NSArray * dataArr = productResult[@"result"];
            [YZViewManager viewManagerWithTextAndView:self.tableView data:dataArr error:error withText:@"该标签暂无售罄产品" block:^{
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
                if (weakSelf.pageCurrent == 1) {
                    [self.dataArray removeAllObjects];
                }
                weakSelf.pageTotal = [productResult [@"totalPage"] integerValue];
                weakSelf.totalCount = [productResult [@"totalCount"] integerValue];
                NSArray *array =[YZProductModel jsonWithData:response];
                for (YZProductModel *model in array) {
                    [weakSelf.dataArray addObject:model];
                }
                    [weakSelf.tableView reloadData];
                    if (weakSelf.pageCurrent >= weakSelf.pageTotal) {
                        //                    [weakSelf.tableView.mj_footer  endRefreshingWithNoMoreData];
                        weakSelf.tableView.mj_footer.hidden = YES;
                    }else {
                        weakSelf.tableView.mj_footer.hidden = NO;                                   }
                
            }];
        } finished:^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
        return;
    }
    [YZHttpApiManager apiSearchListWithParameters:@{@"queryText": self.searchText, @"soldOut": @1, @"pageNum" : @(self.pageCurrent)} completionHandler:^(id response, NSError *error){
        NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
        NSArray * dataArr = productResult[@"result"];
        [YZViewManager viewManagerWithTextAndView:self.tableView data:dataArr error:error withText:@"暂无售罄产品" block:^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.pageCurrent == 1) {
                [self.dataArray removeAllObjects];
            }
            weakSelf.pageTotal = [productResult [@"totalPage"] integerValue];
            weakSelf.totalCount = [productResult [@"totalCount"] integerValue];            NSArray *array =[YZProductModel jsonWithData:response];
            for (YZProductModel *model in array) {
                [weakSelf.dataArray addObject:model];
            }
                [weakSelf.tableView reloadData];
                if (weakSelf.pageCurrent >= weakSelf.pageTotal) {
                    [weakSelf.tableView.mj_footer  endRefreshingWithNoMoreData];
                }else {
                    weakSelf.tableView.mj_footer.hidden = NO;                                   }  
        }];
    } finished:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = YZ_GRAY_COLOR;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"YZSoldOutCell"bundle:[NSBundle mainBundle]]forCellReuseIdentifier:@"outCell"];
        [_tableView registerClass:[HomeProductCell class] forCellReuseIdentifier:NSStringFromClass([HomeProductCell class])];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YZProductModel *product = self.dataArray[indexPath.row];
    HomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductCell class])];
    
//    [cell sendSearchModel:product];
    [cell sendModelViewIndexWith:product];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductModel *product = self.dataArray[indexPath.row];

    return [HomeProductCell returnRowsHeightWith:product];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count > 0) {
        return 1;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 40)];
    backView.backgroundColor = YZ_GRAY_COLOR;
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, S_W - 100, 40)];
    lbl.font = MidFont;
    lbl.text = [NSString stringWithFormat:@"为您找到%@个结果", [NSNumber numberWithInteger:_totalCount]];
    [backView addSubview:lbl];
    return backView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductModel *model = self.dataArray[indexPath.row];
    if (model.detailCheckLogin && !ISLOGIN) {
        [Utility goLogin];
        return;
    }
    YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
    productVC.column = model.column;
    productVC.idProduct = model.ID;
    [self.navigationController pushViewController:productVC animated:YES];
}

@end
