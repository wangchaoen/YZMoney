//
//  SearchHisView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/13.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "SearchHisView.h"
#import "AutoCell.h"
#import "LblChooseCell.h"
#import "SearchHisModel.h"
#define HISTORY_INDEX_FILE @"history_fileArray.plist"
#define HISTORY_NEWS_FILE @"history_news_fileArray.plist"
#define HISTORY_ORDER_FILE @"history_order_fileArray.plist"
#define HISTORY_CONNTRACT_FILE @"history_conntract_fileArray.plist"


@interface SearchHisView ()<UITableViewDataSource, UITableViewDelegate, AutoCellDelegate, LblChooseCellDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *hotArray;

//是否显示过了热词
@property (nonatomic, assign) BOOL isShowHot;
@end

@implementation SearchHisView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.historyArray = [NSMutableArray array];
        self.hotArray = [NSMutableArray array];
        self.array = [NSMutableArray array];
        
        self.backgroundColor = RGBColor(239, 239, 244, 1);
        [self creatView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withComeType:(ComeTypeWithSearch)type {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.historyArray = [NSMutableArray array];
        self.hotArray = [NSMutableArray array];
        self.array = [NSMutableArray array];

        self.backgroundColor = RGBColor(239, 239, 244, 1);
        self.comeType = type;
        [self creatView];
    }
    return self;
}
- (void)setComeType:(ComeTypeWithSearch)comeType {
    _comeType = comeType;
    if (self.comeType == ComeTypeWithSearchIndex) {
        self.filePath = HISTORY_INDEX_FILE;
    }else if (self.comeType == ComeTypeWithSearchNews){
        self.filePath = HISTORY_NEWS_FILE;
    }else if (self.comeType == ComeTypeWithSearchOrder){
        self.filePath = HISTORY_ORDER_FILE;
    }else {
        self.filePath = HISTORY_CONNTRACT_FILE;
    }
    NSArray *array = [YZCacheHelper objectCachedWithFile: self.filePath];
    if (array.count > 0) {
        self.historyArray = [NSMutableArray arrayWithArray:array];
    }
    [self.tableView reloadData];
}
- (void)creatView {
    [self addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.userInteractionEnabled = YES;
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AutoCell class] forCellReuseIdentifier:NSStringFromClass([AutoCell class])];
        [_tableView registerClass:[LblChooseCell class] forCellReuseIdentifier:NSStringFromClass([LblChooseCell class])];
    }
    return _tableView;
}

#pragma mark - utils
- (void)hotSearchWithArray:(NSArray *)array {
    self.hotArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}
- (void)labelSeachWithArray:(NSArray *)array {
    self.array = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}
- (void)searchUitls:(NSString *)searchText {
    if (searchText.length <= 0) {
        return;
    }
    SearchHisModel *model = [[SearchHisModel alloc]init];
    model.searchText = searchText;
    if (self.historyArray.count == 0) {
        [self.historyArray addObject:model];
    }else {
        [self.historyArray insertObject:model atIndex:0];
        if (self.historyArray.count > 15) {
            [self.historyArray removeLastObject];
        }
    }
    [YZCacheHelper cacheObject:self.historyArray file: self.filePath];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger i = 0;
    if (self.historyArray.count > 0) {
        i += 1;
    }
    if (self.array.count > 0) {
        i += 1;
    }
    if (self.hotArray.count > 0) {
        i+= 1;
    }
    return i;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.historyArray.count > 0 && indexPath.row == 0) {
        AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class])];
        [cell createButForArray: self.historyArray];
        cell.titleLbl.text = @"搜索历史";
        cell.delegate = self;
        return cell;
    }else {
        if (self.hotArray.count > 0 && indexPath.row == 0) {
            AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class])];
            [cell createHotArray: self.hotArray];
            cell.delegate = self;
            cell.titleLbl.text = @"热门推荐";
            return cell;
        }else if (self.hotArray.count > 0 && indexPath.row == 1 && !self.isShowHot) {
            AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class])];
            [cell createHotArray: self.hotArray];
            cell.titleLbl.text = @"热门推荐";
            cell.delegate = self;
            return cell;
        }
            LblChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LblChooseCell class])];
            cell.delegate = self;
            [cell createViewForArray: self.array];
            return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat titleLblH = 65;
    if (self.historyArray.count > 0 && indexPath.row == 0) {
        return [AutoCell CalculateRowsHeight:self.historyArray];
    }else {
        if (self.hotArray.count > 0 && indexPath.row == 0) {
            self.isShowHot = YES;
            return [AutoCell CalculateRowsHeight:self.hotArray];
        }else if (self.hotArray.count > 0 && indexPath.row == 1 && !self.isShowHot){
            return [AutoCell CalculateRowsHeight:self.hotArray];
        }
        return 10 + titleLblH + (25 + 5) * ((self.array.count - 1) / 3 + 1);
    }
    return 0;
}

#pragma mark - customDelegate
// 历史记录
- (void)deleteHistoryAction {
    //删除
    BOOL judge = [YZCacheHelper deleteCachedWithFile: self.filePath];
    if (judge) {
        [YZToastView showToastWithText:@"删除成功"];
        [self.historyArray removeAllObjects];
        [self.tableView reloadData];
    }else {
        [YZToastView showToastWithText:@"删除失败"];
    }
}

//标签 热词
- (void)chooseButAction:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(historySearchAction: isLabel:)]) {
        SearchHisModel *model = self.array[but.tag];
        [self.delegate historySearchAction:model isLabel:YES];
    }
}

- (void)touchHistoryAction:(UIButton *)but type:(BOOL)type{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(historySearchAction: isLabel:)]) {
        SearchHisModel *model;
        if (type) {
            model = self.historyArray[but.tag];
        }else {
            model = self.hotArray[but.tag];
        }
        [self.delegate historySearchAction:model isLabel:NO];
    }
}
@end
