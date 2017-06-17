//
//  YZNewsSV.m
//  YZMoney
//
//  Created by 7仔 on 15/11/11.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZNewsSV.h"
#import "YZNewsModel.h"
#import "YZNewsDetailVC.h"
#import "YZNewsCell.h"
#import "ProductNameModel.h"



@interface YZNewsSV () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dicNews;
@property (nonatomic, strong) NSMutableDictionary *dicPageTotal;
@property (nonatomic, strong) NSMutableDictionary *dicPageCurrent;
@property (nonatomic, strong) NSMutableDictionary *dicPageEnable;

@end





@implementation YZNewsSV

- (void)setArrCategory:(NSArray *)arrCategory {
    self.delegate    = self;
    _arrCategory     = arrCategory;
    _dicNews         = [NSMutableDictionary dictionary];
    _dicPageTotal    = [NSMutableDictionary dictionary];
    _dicPageCurrent  = [NSMutableDictionary dictionary];
    _dicPageEnable   = [NSMutableDictionary dictionary];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*_arrCategory.count, CGRectGetHeight(self.frame));
    
    for (NSInteger i=0; i<_arrCategory.count; i++) {
        ProductNameModel *model = _arrCategory[i];
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)*i, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        tv.dataSource = self;
        tv.delegate = self;
        tv.backgroundColor = YZ_GRAY_COLOR;
        tv.accessibilityIdentifier = model.code;
        tv.tableFooterView = [[UIView alloc] init];
        [tv registerClass:[YZNewsCell class] forCellReuseIdentifier:NSStringFromClass([YZNewsCell class])];
        [self addSubview:tv];
        WEAK_SELF;
        [Utility MJRefreshHeaderGif:tv headerWithRefreshingBlock:^{
            [weakSelf loadListWithParameter:@{@"typeCode": tv.accessibilityIdentifier,
                                              @"pageNum" : @(1)}
                                    refresh:YES page:NO];
            
        }];
        tv.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadListWithParameter:@{@"typeCode" : tv.accessibilityIdentifier,
                                                                                    @"pageNum"  : @([_dicPageCurrent[tv.accessibilityIdentifier] integerValue]+1)}
                                                                          refresh:NO page:YES];

        }];
        tv.mj_footer.hidden = YES;
    }
    
    if (_arrCategory) {
        ProductNameModel *model = _arrCategory[0];
        [self loadListWithParameter:@{@"typeCode": model.code,
                                      @"pageNum" : @(1)}
                            refresh:NO page:NO];
    }
}

- (void)loadListWithParameter:(id)parameter refresh:(BOOL)refresh page:(BOOL)page {
    NSString *category = parameter[@"typeCode"];
    
    if (!_dicNews[category] || refresh || page) {
        NSString *url = [NSString stringWithFormat:@"article/%@", category];
        [_dicPageEnable setValue:@(NO) forKey:category];
//        WEAK_SELF;
        [YZHttpApiManager apiNewsListWithParameters:parameter url:url
                                  completionHandler:^(id response, NSError *error) {
                                      if (response) {
                                          NSMutableArray *arr = [_dicNews[category] mutableCopy] ? : [NSMutableArray array];
                                          if ([parameter[@"pageNum"] integerValue]== 1) {
                                              _dicNews[category] = [NSMutableArray array];
                                          }

                                          if (refresh) {
                                              [arr removeAllObjects];
                                          }
                                          for (NSDictionary *dic in [response valueForKeyPath:@"data.articleResult.result"]) {
                                              [arr addObject:[[[YZNewsModel alloc] init] modelFromJson:dic]];
                                          }
                                          [_dicNews        setValue:arr forKey:category];
                                          [_dicPageTotal   setValue:[response valueForKeyPath:@"data.articleResult.totalPage"] forKey:category];
                                          [_dicPageCurrent setValue:[response valueForKeyPath:@"data.articleResult.currentPage"] forKey:category];
                                          [_dicPageEnable  setValue:@(YES) forKey:category];
                                          
                                          [YZCacheHelper cacheObject:_dicNews file:@"news_list"];
                                      }
                                      else {
                                          NSMutableDictionary *dic = [YZCacheHelper objectCachedWithFile:@"news_list"];
                                          [_dicNews setValue:dic[category] forKey:category];
                                      }
                                      
                                      for (UIView *v in self.subviews) {
                                          if ([v.accessibilityIdentifier isEqualToString:category]) {
                                              [[(UITableView *)v mj_header] endRefreshing];
                                              [YZViewManager viewManagerWithView:v
                                                                            data:_dicNews[category]
                                                                           error:error
                                                                           block:^{
                                                                               
                                                                           }];
                                              UITableView *tableView = (UITableView *)v;                                        [(UITableView *)v reloadData];
                                              [tableView.mj_footer endRefreshing];
                                              if ([_dicPageCurrent[category] integerValue] >= [_dicPageTotal[category] integerValue]) {
                                                  //                                                                                   tableView.mj_footer.hidden = YES;
                                                  [tableView.mj_footer  endRefreshingWithNoMoreData];
                                              }else {
                                                  tableView.mj_footer.hidden = NO;
                                              }
                                              
                                              
                                          }
                                      }
                                  } finished:^{
                                      
                                  }];
    }
}


#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSString *category = scrollView.accessibilityIdentifier;
        if ((scrollView.contentSize.height-scrollView.contentOffset.y-CGRectGetHeight(scrollView.frame) < 100.0f) &&
            [_dicPageCurrent[category] integerValue] < [_dicPageTotal[category] integerValue] &&
            [_dicPageEnable[category] boolValue])
        {
            [self loadListWithParameter:@{@"typeCode" : category,
                                          @"pageNum"  : @([_dicPageCurrent[category] integerValue]+1)}
                                refresh:NO page:YES];
        }
    }
    else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        _backgroundViewAnimationBlock(scrollView.contentOffset.x);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        [self newsScrollViewRequest:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        [self newsScrollViewRequest:scrollView];
    }
}
- (void)newsScrollViewRequest:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    ProductNameModel *model = _arrCategory[index];
    [self loadListWithParameter:@{@"typeCode": model.code,
                                  @"pageNum" : @(1)}
                        refresh:NO page:NO];
}

#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [_dicNews valueForKey:tableView.accessibilityIdentifier];
    return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [_dicNews valueForKey:tableView.accessibilityIdentifier];
    YZNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZNewsCell class])];
    if (indexPath.row < arr.count) {
        YZNewsModel *news = arr[indexPath.row];
        cell.titleLbl.text = news.title;
        cell.timeLbl.text = [YZHelper dateStringFromTimestamp:news.publishDate];
        
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self endEditing:YES];
    
    NSArray *arr = [_dicNews valueForKey:tableView.accessibilityIdentifier];
    YZNewsModel *news = arr[indexPath.row];
    [_vc performSegueWithIdentifier:@"segue_news_detail" sender:news];
}

@end
