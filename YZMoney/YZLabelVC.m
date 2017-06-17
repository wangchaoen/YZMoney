//
//  YZLabelVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/14.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZLabelVC.h"
//#import "YZSearchProductModel.h"
#import "YZProductModel.h"
#import "YZProductDetailVC.h"
#import "YZSoldOutCell.h"
#import "YZSoldOutController.h"
#import "HomeProductCell.h"

@interface YZLabelVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageTotal;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL requestSuccess;
@end

@implementation YZLabelVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserHasGet object:nil];
}
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        if (title) {
            self.title = title;
        }else {
            self.title = @"";
        }
    }
    return self;
}
- (void)userHasGet {
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasGet) name:kUserHasGet object:nil];

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 64)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    self.dataArray = [NSMutableArray array];
    self.currentPage = 1;
    [self.view addSubview:self.tableView];
    [self requestWithLabel];
    WEAK_SELF;
    [Utility MJRefreshHeaderGif:self.tableView headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf requestWithLabel];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestWithLabel];
    }];
    self.tableView.mj_footer.hidden = YES;
}
- (void)requestWithLabel {
    WEAK_SELF;
    [YZHttpApiManager apiSearchCategorySearchLabelWithParameters:@{@"queryText": self.title, @"pageNum": @(self.currentPage)} completionHandler:^(id response, NSError *error){
        NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
        NSArray * dataArr = productResult[@"result"];

        [YZViewManager viewManagerWithTextAndView:self.tableView data:dataArr error:error withText:@"该标签暂无预热在售产品" block:^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            weakSelf.requestSuccess = YES;
            weakSelf.pageTotal = [productResult [@"totalPage"] integerValue];
            weakSelf.totalCount = [productResult [@"totalCount"] integerValue];
            NSArray *array = [YZProductModel jsonWithData:response];
            for (YZProductModel *model in array) {
                [weakSelf.dataArray addObject:model];
            }                                               [weakSelf.tableView reloadData];

            [Utility tableViewFooterHiddenWith:weakSelf.tableView currentPage:weakSelf.currentPage totalPage:weakSelf.pageTotal];
            
        }];
    } finished:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, S_W, S_H - 64)];
        _tableView.backgroundColor = YZ_GRAY_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HomeProductCell class] forCellReuseIdentifier:NSStringFromClass([HomeProductCell class])];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductCell class])];
    YZProductModel *product = self.dataArray[indexPath.row];
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
    if (self.requestSuccess) {
        return 1;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 40)];
    backView.backgroundColor = YZ_GRAY_COLOR;
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, S_W - 100, 40)];
    lbl.font = MidFont;
    lbl.text = [NSString stringWithFormat:@"为您找到%@个结果", [NSNumber numberWithInteger:_totalCount? : 0]];
    [backView addSubview:lbl];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"查看售罄产品" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:12];
    but.frame = CGRectMake(S_W - 85, 0, 80, 40);
    [but setImage:[UIImage imageNamed:@"nextPage_icon"] forState:UIControlStateNormal];
    but.imageEdgeInsets = UIEdgeInsetsMake(0, 65, 0, 0);
    but.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 15);
    [but setTitleColor:YZ_RED_COLOR forState:UIControlStateNormal];
    [but addTarget:self action:@selector(showSoldOutAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:but];

    return backView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductModel *model = self.dataArray[indexPath.row];
    if (model.detailCheckLogin && !ISLOGIN) {
        [Utility goLogin];
        return;
    }
    YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
    productVC.idProduct = model.ID;
    productVC.column = model.column;
    [self.navigationController pushViewController:productVC animated:YES];
}

- (void)showSoldOutAction {
    YZSoldOutController *vc = [[YZSoldOutController alloc]initWithTitle:self.title comeType:SoldOutComeTypeLabel];
    [self.navigationController pushViewController:vc animated:YES];
}
@end