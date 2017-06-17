//
//  YZContractView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/11.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZContractView.h"
#import "YZContractCell.h"

#define TABLEVIEW_TAG 1000

@interface YZContractView ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, YZContractCellDelegate>
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataArray;
@property (nonatomic, strong) NSMutableArray *currentPageArray;
@property (nonatomic, strong) NSMutableArray *totalPageArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@end

@implementation YZContractView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZ_GRAY_COLOR;
        self.dataArray = [[NSMutableArray alloc] initWithArray:@[[NSMutableArray array],[NSMutableArray array]]];
        self.currentPageArray = [NSMutableArray arrayWithArray:@[@1, @1]];
        self.totalPageArray = [NSMutableArray arrayWithArray:@[@1, @1]];
        self.searchArray = [NSMutableArray arrayWithArray:@[@"", @""]];
        
        for (int i = 0; i < 2; i++) {
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(i * S_W, 0, S_W, self.frame.size.height)];
            table.backgroundColor = YZ_GRAY_COLOR;
            table.tag = i + TABLEVIEW_TAG;
            table.delegate = self;
            table.dataSource = self;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.tableFooterView = [UIView new];
            [table registerClass:[YZContractCell class] forCellReuseIdentifier:NSStringFromClass([YZContractCell class])];
            WEAK_SELF;
            [Utility MJRefreshHeaderGif:table headerWithRefreshingBlock:^{
                [self requestWithCurrentPage:1];
            }];
            table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self requestWithCurrentPage:                [weakSelf.currentPageArray[i] integerValue] + 1];
            }];
            table.mj_footer.hidden = YES;
            [self addSubview:table];
        }
        self.contentSize = CGSizeMake(S_W * 2, 0);
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        [self requestWithCurrentPage:1];
    }
    return self;
}
#pragma mark - request
- (void)requestWithCurrentPage:(NSInteger)currentPage {
    NSInteger i = [self returnCurrentPage];
    self.currentPageArray[i] = @(currentPage);
    UITableView * tableView = (UITableView *)[self viewWithTag:i + TABLEVIEW_TAG];
    NSString * searchText = self.searchArray[i];
    NSString *url = i == 0 ? @"member/compact/list" : @"member/compact/apply/list";
    WEAK_SELF;
    [YZHttpClient requestWithNoToastMethod:@"POST" url: url parameters:@{@"queryText": searchText, @"pageNum": @(currentPage)} completionHandler:^(id response, NSError *error) {
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        if (response) {
            weakSelf.totalPageArray[i] = [response valueForKeyPath:@"data.compactData.totalPage"];
            NSString *str = i == 0 ? (searchText.length > 0 ? @"无符合搜索条件的结果" : @"该项目暂未开放合同申请") : (searchText.length > 0 ? @"无符合搜索条件的结果" : @"暂无合同申请记录");
            [YZViewManager viewManagerWithTextAndView:tableView data:[response valueForKeyPath:@"data.compactData.result"] error:error withText:str block:^{
                if (currentPage == 1) {
                    [weakSelf.dataArray[i] removeAllObjects];
                }
                NSArray *array = [response valueForKeyPath:@"data.compactData.result"];
                if (searchText.length > 0 && array.count > 0) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 40)];                                             UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, S_W, 30)];
                    lbl.text = [NSString stringWithFormat:@"以下为搜索%@的结果", searchText];
                    lbl.textAlignment = NSTextAlignmentCenter;                           lbl.font = MidFont;
                    [view addSubview:lbl];
                    tableView.tableHeaderView = view;
                }else {
                    tableView.tableHeaderView = nil;
                }
                
                for (NSDictionary *dic in array) {
                    YZContractModel *model = [[YZContractModel alloc]initWithDict:dic];
                    [weakSelf.dataArray[i] addObject:model];
                }
                [tableView reloadData];
                
                if (currentPage >= [weakSelf.totalPageArray[i] integerValue]) {
                    tableView.mj_footer.hidden = YES;
                }else{
                    tableView.mj_footer.hidden = NO;
                }
            }];
        }
    } finished:^{
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - publicAction
- (void)searchActionWithText:(NSString *)text{
    if (text.length > 0) {
        self.searchArray[[self returnCurrentPage]] = text;
    }else {
        self.searchArray[[self returnCurrentPage]] = @"";
    }
    [self requestWithCurrentPage:1];
}
- (NSInteger)returnCurrentPage {
    NSInteger i = self.contentOffset.x / S_W;
    return i;
}
- (void)scrollRequest{
    if (self.dataArray[[self returnCurrentPage]].count == 0) {
        self.searchArray[[self returnCurrentPage]] = @"";
        [self requestWithCurrentPage:1];
    }else {
        NSString *str = self.searchArray[[self returnCurrentPage]];
        if (str.length > 0) {
            self.searchArray[[self returnCurrentPage]] = @"";
            [self requestWithCurrentPage:1];
        }
    }
}
#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITableView class]]) {

    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(scrollViewDidEndScroll)]) {
        [self.viewDelegate scrollViewDidEndScroll];
    }
    [self scrollRequest];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(scrollViewDidEndScroll)]) {
        [self.viewDelegate scrollViewDidEndScroll];
    }
    [self scrollRequest];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[tableView.tag - TABLEVIEW_TAG].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZContractCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZContractCell class])];
    cell.delegate = self;
    NSMutableArray *array = [self.dataArray objectAtIndex:tableView.tag - TABLEVIEW_TAG];
    YZContractModel *model = array[indexPath.row];
    model.type = tableView.tag - TABLEVIEW_TAG;
    [cell sendWithModel:model index:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(clickTableCellAction)]) {
        [self.viewDelegate clickTableCellAction];
    }
}
- (void)butClickActionWithCell:(YZContractCell *)cell but:(UIButton *)but {
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(clickButCellActionWithModel:)]) {
        NSMutableArray *array = [self.dataArray objectAtIndex:[self returnCurrentPage]];
       YZContractModel *model = array[but.tag];
        [self.viewDelegate clickButCellActionWithModel:model];
    }
}
@end
