//
//  YZSearchVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/9.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZSearchVC.h"

#import "YZProductModel.h"
#import "YZSearchNewsModel.h"
#import "YZProductDetailVC.h"
#import "YZNewsDetailVC.h"
#import "YZSearchLWModel.h"
#import "SearchHisView.h"
#import "SearchHisModel.h"
#import "SearchNavView.h"
#import "YZSoldOutController.h"
#import "YZLabelVC.h"
#import "HomeProductCell.h"

@interface YZSearchVC () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchHisViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *svSearchCate;
@property (weak, nonatomic) IBOutlet UITableView *tvSearchResult;

@property (nonatomic, strong) NSArray *arrSearchCate;
@property (nonatomic, assign) NSInteger indexCate;

@property (nonatomic, copy) NSString *textSearch;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger pageTotal;
@property (nonatomic, assign) NSInteger pageCurrent;
@property (nonatomic, assign) BOOL pageEnable;

//判断是搜索还是联想
@property (nonatomic, assign, getter=isSrearch) BOOL search;

// 搜索出关键字结果
// 历史记录
@property (nonatomic, strong)SearchHisView *searchView;

@property (nonatomic, strong)SearchNavView *searchNav;
@end





@implementation YZSearchVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserHasGet object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchNav.textField resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.isIndexCome) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
}
- (void)userHasGet {
    [self.tvSearchResult reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)textFiledEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (!toBeString.length) {
        [_arrSearchResult removeAllObjects];
        [_tvSearchResult reloadData];
    }
    // 判断显示搜索关键字结果
    if (toBeString.length > 0) {
        _textSearch = toBeString;
        self.search = NO;
        [self reloadRequest];
    } else {
        self.searchView.hidden = false;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasGet) name:kUserHasGet object:nil];
    self.textSearch = @"";
    WEAK_SELF;
    [Utility MJRefreshHeaderGif:self.tvSearchResult headerWithRefreshingBlock:^{
        weakSelf.pageCurrent = 1;
        [weakSelf searchEvent];
    }];
    
    self.tvSearchResult.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageCurrent++;
        [weakSelf searchEvent];
    }];
    self.tvSearchResult.backgroundColor = YZ_GRAY_COLOR;
    [self.tvSearchResult registerClass:[HomeProductCell class] forCellReuseIdentifier:NSStringFromClass([HomeProductCell class])];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

    self.tvSearchResult.frame = CGRectMake(0, 64, S_W, S_H - 64);
    
    _arrSearchResult = [NSMutableArray array];
    _pageCurrent = 1;
    _pageEnable = YES;
    [self.view addSubview:self.searchView];
    
    SearchNavView *searchNav = [[SearchNavView alloc]initWithFrame:CGRectMake(0, 20, S_W, 44)];
    self.searchNav = searchNav;
    
    [self.searchNav.backBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchNav.searchBut addTarget:self action:@selector(searchButAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchNav.textField.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.searchNav.textField];
    [self.view addSubview:searchNav];
    
//    [YZHttpApiManager apiSearchCategoryWithParameters:nil
//                                    completionHandler:^(id response, NSError *error) {
//                                        _arrSearchCate = response[@"data"];
//                                    }];
    [YZHttpApiManager apiSearchCategoryHotAndLabelWithParameters:nil completionHandler:^(id response, NSError *error) {
        if (response) {
            NSDictionary *data = response[@"data"];
            NSArray *arr1 = data[@"recommonList"];
            NSArray *arr2 = data[@"hotTagList"];
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];
            for (NSDictionary *dic in arr1) {
                SearchHisModel * model = [[SearchHisModel alloc]init];
                model.searchText = dic[@"name"];
                model.contentId = dic[@"id"];
                model.column = dic[@"column"];
                [array1 addObject:model];
            }
            [weakSelf.searchView hotSearchWithArray:array1];
            for (NSString *str in arr2) {
                SearchHisModel * model = [[SearchHisModel alloc]init];
                model.searchText = str;
                [array2 addObject:model];
            }
            [weakSelf.searchView labelSeachWithArray:array2];
         }
    } finished:^{
        
    }];
    
}
- (SearchHisView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchHisView alloc]initWithFrame:CGRectMake(0, 64, S_W, S_H - 64) withComeType:ComeTypeWithSearchIndex];
        _searchView.delegate = self;
//        [self.searchNav.textField resignFirstResponder]
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTextField)];
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}

- (void)searchEvent {
    if (_textSearch && _textSearch.length > 0) {
        self.tvSearchResult.mj_footer.hidden = YES;
        self.searchView.hidden = true;
        _pageEnable = NO;
        WEAK_SELF;
        if (!self.search) {
            [YZHttpClient requestWithNoToastMethod:@"POST" url:@"search/associate" parameters:@{@"queryText": _textSearch, @"pageNum": @(_pageCurrent)} completionHandler:^(id response, NSError *error) {
                [weakSelf requestUtilsWithResponse:response error:error];
                
            } finished:^{
                [weakSelf.tvSearchResult.mj_footer endRefreshing];
                [weakSelf.tvSearchResult.mj_header endRefreshing];
            }];
            return;
        }
        [MobClick event:@"index_search"];
        [YZHttpApiManager apiSearchListWithParameters:@{@"queryText": _textSearch, @"pageNum"  : @(_pageCurrent)}
                                    completionHandler:^(id response, NSError *error) {
                                        [weakSelf requestUtilsWithResponse:response error:error];
                                    } finished:^{
                                        [weakSelf.tvSearchResult.mj_header endRefreshing];
                                        [weakSelf.tvSearchResult.mj_footer endRefreshing];
                                    }];
    }
}
#pragma mark - utils
- (void)reloadView {
    [self.searchNav.textField resignFirstResponder];
    self.textSearch = self.searchNav.textField.text;
    [self reloadRequest];
}
- (void)reloadRequest {
    _pageCurrent = 1;
    [self searchEvent];

}
- (void)requestUtilsWithResponse:(id)response error:(NSError *)error {
    NSDictionary *productResult = [response valueForKeyPath:@"data.productResult"];
    NSArray * dataArr = productResult[@"result"];
    WEAK_SELF;
    [YZViewManager viewManagerWithTextAndView:_tvSearchResult
                                         data:dataArr
                                        error:error withText: @"无符合搜索字段的预热在售产品"
                                        block:^{
                                            if (weakSelf.pageCurrent == 1) {                                     [weakSelf.arrSearchResult removeAllObjects];                                }
                                            _pageEnable = YES;
                                            _totalCount = [productResult [@"totalCount"] integerValue];
                                            _pageTotal = [productResult [@"totalPage"] integerValue];
                                            NSArray * array =[YZProductModel jsonWithData:response];
                                            for (YZProductModel *model in array) {
                                                [_arrSearchResult addObject:model];
                                            }
                                            
                                            [_tvSearchResult reloadData];
                                            if (        weakSelf.pageCurrent >= weakSelf.pageTotal) {
                                                [weakSelf.tvSearchResult.mj_footer  endRefreshingWithNoMoreData];
                                            }else {
                                                weakSelf.tvSearchResult.mj_footer.hidden = NO;                                   }
                                        }];
}
#pragma mark - action
- (void)showSoldOutAction {
    YZSoldOutController *vc = [[YZSoldOutController alloc]init];
    vc.searchText = self.textSearch;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)resignTextField {
    [self.searchNav.textField resignFirstResponder];
}
- (void)searchButAction:(UIButton *)but {
    if (self.searchNav.textField.text.length > 0) {
        [self.searchView searchUitls:self.searchNav.textField.text];

//        if (_arrSearchResult.count > 0) {
//            [_tvSearchResult.mj_header beginRefreshing];
//        }else{
            self.search = YES;
            [self reloadView];

//        }
    }

}
- (IBAction)actionBack:(UIBarButtonItem *)sender {
    [self backAction];
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)actionSearch:(UIBarButtonItem *)sender {
    if (self.searchNav.textField.text.length > 0) {
//        if (_arrSearchResult.count > 0) {
//            [_tvSearchResult.mj_header beginRefreshing];
//            
//        }else {
        [self.searchView searchUitls:self.searchNav.textField.text];
        self.search = YES;
        [self reloadView];
//        }
    }
}

- (void)clickCategoryWithSender:(UIButton *)sender {

}
#pragma mark - customDelegate
- (void)historySearchAction:(SearchHisModel *)model isLabel:(BOOL)isLabel{
    if (model.contentId) {
        [self.searchNav.textField resignFirstResponder];
        YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
        productVC.column = model.column;
        productVC.idProduct = model.contentId;
        [self.navigationController pushViewController:productVC animated:true];
    }else {
//        self.searchBar.text = model.searchText;
        if (isLabel) {
            YZLabelVC *vc = [[YZLabelVC alloc]initWithTitle:model.searchText];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        self.searchNav.textField.text = model.searchText;
        [self reloadView];
    }
}
#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchView.hidden = false;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self.searchView searchUitls:textField.text];
        [self reloadView];
    }
    return YES;
}
#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self.navigationController.navigationBar endEditing:YES];
    [self.searchNav.textField resignFirstResponder];
}


#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrSearchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZProductModel *model = [self.arrSearchResult objectAtIndex:indexPath.row];
        return [HomeProductCell returnRowsHeightWith:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 40)];
    backView.backgroundColor = YZ_GRAY_COLOR;
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, S_W - 100, 40)];
    lbl.font = MidFont;
    lbl.text = [NSString stringWithFormat:@"为您找到%@个结果", [NSNumber numberWithInteger:_totalCount ? : 0]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductCell class])];
    YZProductModel *model = [self.arrSearchResult objectAtIndex:indexPath.row];
    [cell sendModelViewIndexWith:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.view endEditing:YES];

        YZProductModel *model = _arrSearchResult[indexPath.row];
        if (model.detailCheckLogin && !ISLOGIN) {
            [Utility goLogin];
            return;
        }
        YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
        productVC.idProduct = model.ID;
        [self.navigationController pushViewController:productVC animated:YES];
}


#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"segue_searchProduct_detail"]) {
//        NSIndexPath *ip = _tvSearchResult.indexPathForSelectedRow;
//        [(YZProductDetailVC *)segue.destinationViewController setIdProduct:[_arrSearchResult[ip.row] ID]];
//        
//    }
//    else
        if ([segue.identifier isEqualToString:@"smegue_searchNews_detail"]) {
        NSIndexPath *ip = _tvSearchResult.indexPathForSelectedRow;
        [(YZNewsDetailVC *)segue.destinationViewController setIdNews:[_arrSearchResult[ip.row] ID]];
    }
}
@end
