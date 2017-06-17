//
//  YZProductSV.m
//  YZMoney
//
//  Created by 7仔 on 15/11/10.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZProductSV.h"
#import "YZProductModel.h"
#import "HomeProductCell.h"
#import "ProductNameModel.h"




@interface YZProductSV () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
//所有model
@property (nonatomic, strong) NSMutableDictionary *dicProduct;
//总页数
@property (nonatomic, strong) NSMutableDictionary *dicPageTotal;
//当前页数
@property (nonatomic, strong) NSMutableDictionary *dicPageCurrent;
//加载过
@property (nonatomic, strong) NSMutableDictionary *dicPageEnable;
//所有加载过的页数
@property (nonatomic, strong) NSMutableDictionary *dicCondition;

@end





@implementation YZProductSV

- (void)setArrCategory:(NSArray<ProductNameModel *> *)arrCategory {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHasGet:)
                                                 name:kUserHasGet
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHasRemove:)
                                                 name:kUserHasRemove
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenAction:) name:NOT_PRODUCT_SCREEN object:nil];
    self.delegate    = self;
    _arrCategory     = arrCategory;
    _dicProduct      = [NSMutableDictionary dictionary];
    _dicPageTotal    = [NSMutableDictionary dictionary];
    _dicPageCurrent  = [NSMutableDictionary dictionary];
    _dicPageEnable   = [NSMutableDictionary dictionary];
    _dicCondition    = [NSMutableDictionary dictionary];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*_arrCategory.count, CGRectGetHeight(self.frame));
    
    for (NSInteger i=0; i<_arrCategory.count; i++) {
        ProductNameModel *model = _arrCategory[i];
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)*i, 0.0f,
                                                                        CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        tv.dataSource = self;
        tv.delegate   = self;
        tv.backgroundColor = YZ_GRAY_COLOR;
        tv.accessibilityIdentifier = model.code;
        tv.tableFooterView = [[UIView alloc] init];
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.estimatedRowHeight = 180.0f;
        [self addSubview:tv];
        WEAK_SELF;
        [tv registerClass:[HomeProductCell class] forCellReuseIdentifier:NSStringFromClass([HomeProductCell class])];
        [Utility MJRefreshHeaderGif:tv headerWithRefreshingBlock:^{
            [_dicCondition[tv.accessibilityIdentifier] setValue:@(1) forKey:@"pageNum"];
            [weakSelf loadListWithParameters:_dicCondition[tv.accessibilityIdentifier] refresh:YES page:NO filter:NO];
            
        }];

        NSString *category = tv.accessibilityIdentifier;
        
        tv.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [_dicCondition[category] setValue:@([_dicPageCurrent[category] integerValue]+1) forKey:@"pageNum"];
            [weakSelf loadListWithParameters:_dicCondition[category] refresh:NO page:YES filter:NO];
        }];
        tv.mj_footer.hidden = YES;
    }
    
    if (_arrCategory) {
        ProductNameModel *model = _arrCategory[0];
        [self loadListWithParameters:@{@"columnUrl"   : model.code,
                                       @"pageNum": @(1)}
                             refresh:NO page:NO filter:NO];
    }
}
//筛选回调
- (void)screenAction:(NSNotification *)not {
        [self loadListWithParameters:not.userInfo refresh:NO page:NO filter:YES];
}
- (void)loadListWithParameters:(id)parameters refresh:(BOOL)refresh page:(BOOL)page filter:(BOOL)filter {
    
    NSString *category = parameters[@"columnUrl"];
    if (!_dicProduct[category] || refresh || page || filter) {
        if (!category) {
            return;
        }
        [_dicPageEnable setValue:@(NO) forKey:category];
        WEAK_SELF;
        NSString *url = [NSString stringWithFormat: @"open/product/%@", parameters[@"columnUrl"]];
        [YZHttpApiManager apiProductListWithParameters:parameters url:url
                                     completionHandler:^(id response, NSError *error) {

                                         if (response) {
                                            NSMutableArray *arr = [_dicProduct[category] mutableCopy] ? : [NSMutableArray array];
                                             if (refresh || filter) {
                                                 [arr removeAllObjects];
                                             }
                                             NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
//                                             NSArray * dataArr = productResult[@"result"];
                                             NSArray *array = [YZProductModel jsonWithData:response];
                                             for (YZProductModel *model in array) {
                                                 [arr addObject:model];
                                             }
                                             
                                             [_dicProduct     setValue:arr forKey:category];
                                             [_dicPageTotal   setValue:productResult [@"totalPage"] forKey:category];
                                             [_dicPageCurrent setValue:productResult [@"currentPage"] forKey:category];
                                             [_dicPageEnable  setValue:@(YES) forKey:category];
                                             [_dicCondition   setValue:[parameters mutableCopy] forKey:category];
                                             
                                             if ([[parameters allKeys] count] == 2) {
                                                 [YZCacheHelper cacheObject:_dicProduct file:@"product_list"];
                                             }
                                         }
                                         else {
                                             if ([[parameters allKeys] count] == 2) {
                                                 NSMutableDictionary *dic = [YZCacheHelper objectCachedWithFile:@"product_list"];
                                                 [_dicProduct setValue:dic[category] forKey:category];
                                                 [_dicCondition setValue:[parameters mutableCopy] forKey:category];
                                             }
                                         }
                                         
                                         for (UIView *v in self.subviews) {
                                             if ([v.accessibilityIdentifier isEqualToString:category]) {
                                                 [[(UITableView *)v mj_header] endRefreshing];
                                                 NSDictionary *paraDic = (NSDictionary *)parameters;
                                                 NSString *text = @"暂无预热和在售产品";
                                                 if (paraDic.count > 2) {
                                              text = @"无符合筛选条件的产品";
                                                 }
                                                 [YZViewManager viewManagerWithTextAndView: v
                                                                               data: _dicProduct[category]
                                                                              error: error withText: text
                                                                              block:^{
                                                                                  NSArray *array = _dicProduct[category];
                                            UITableView *tableView = (UITableView *)v;
                                                                                  if (paraDic.count > 2 && array.count > 0) {
                                                                                      UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 40)];                                             UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, S_W, 30)];
                                                                                      lbl.text = @"以下为筛选后的产品";
                                          lbl.textAlignment = NSTextAlignmentCenter;                           lbl.font = MidFont;
                                                                                      [view addSubview:lbl];
                                                                                      tableView.tableHeaderView = view;                                }else {
                                                                                                                            tableView.tableHeaderView = nil;                                       }
                                                                                  
                                                                                  [tableView reloadData];                                      [tableView.mj_footer endRefreshing];
                                                                                  if ([weakSelf.dicPageCurrent[category] integerValue] >= [weakSelf.dicPageTotal[category] integerValue]) {
                                                                                      
                                    [tableView.mj_footer  endRefreshingWithNoMoreData];                                              }else {                                                 tableView.mj_footer.hidden = NO;
                                    }}];
                                             }
                                         }
                                     } finished:^{
                                         
                                     }];
    }
}

- (void)userHasGet:(NSNotification *)noti {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UITableView class]]) {
            [(UITableView *)v reloadData];
        }
    }
}

- (void)userHasRemove:(NSNotification *)noti {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UITableView class]]) {
            [(UITableView *)v reloadData];
        }
    }
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
if ([scrollView isKindOfClass:[UIScrollView class]]) {
        _backgroundViewAnimationBlock(scrollView.contentOffset.x);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        [self scrollRefreshUtils:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        [self scrollRefreshUtils:scrollView];
    }
}
- (void)scrollRefreshUtils:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    ProductNameModel *model = _arrCategory[index];
    //        NSString *type = dic[@"key"];
    BOOL refresh = NO;
    //        if ([DataManager sharedManager].productDic[type]) {
    //            refresh = YES;
    //            [[DataManager sharedManager].productDic removeObjectForKey:type];
    //        }
    [MobClick event:@"list_sort" label:[NSString stringWithFormat:@"tab%ld_%@", (long)index,model.code]];
    
    [self loadListWithParameters:@{@"columnUrl"   : model.code,
                                   @"pageNum": @(1)}
                         refresh:refresh page:NO filter:NO];
    
}

#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dicProduct valueForKey:tableView.accessibilityIdentifier] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HomeProductCell returnRowsHeightWith:[_dicProduct valueForKey:tableView.accessibilityIdentifier][indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductCell class])];
    [cell sendModelViewIndexWith:[_dicProduct valueForKey:tableView.accessibilityIdentifier][indexPath.row]];
//    YZProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_product"];
//    if (!cell) {
//        cell = [[YZProductCell alloc] init];
//    }
//    [cell configureCellWithProduct:[_dicProduct valueForKey:tableView.accessibilityIdentifier][indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self endEditing:YES];
    NSArray *arr = [_dicProduct valueForKey:tableView.accessibilityIdentifier];
    YZProductModel *product = arr[indexPath.row];

    if (product.detailCheckLogin && !ISLOGIN) {
        [Utility goLogin];
        return;
    }
    [_vc performSegueWithIdentifier:@"segue_product_detail" sender:product];
}

@end
