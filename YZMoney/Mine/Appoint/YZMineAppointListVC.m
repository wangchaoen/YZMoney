//
//  YZMineAppointVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/18.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZMineAppointListVC.h"
#import "YZAppointModel.h"
#import "YZMineAppointDetailVC.h"
#import "YZProductAppointVC.h"
#import "YZMineAppointConditionView.h"
#import "YZOrderCell.h"
#import "YZAppSearchController.h"


@interface YZMineAppointListVC ()

@property (nonatomic, strong) NSMutableArray *arrAppoint;
@property (nonatomic, strong) YZMineAppointConditionView *viewCondition;
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) NSMutableDictionary *parameterDic;
@end

@implementation YZMineAppointListVC
- (void)showScreeningAction:(UIButton *)but {
    if (_viewCondition.superview) {
        [_viewCondition removeFromSuperview];
        self.titleImage.image = [UIImage imageNamed:@"show_image"];
        
    }else {
        [self actionCondition];
        self.titleImage.image = [UIImage imageNamed:@"show_image_up"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = rightBut;
    
    self.parameterDic = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNum": @1}];
    _arrAppoint = [NSMutableArray array];
    
    [self createTitleView];
    
    [self apiManagerAll];
    
    [self.tableView registerClass:[YZOrderCell class] forCellReuseIdentifier:NSStringFromClass([YZOrderCell class])];
    self.tableView.backgroundColor = YZ_GRAY_COLOR;
    
    WEAK_SELF;
//    [Utility MJRefreshHeaderGif:self.tableView headerWithRefreshingBlock:^{
//        weakSelf.parameterDic[@"pageNum"] = @1;
//        [weakSelf apiManagerAll];
//    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.parameterDic[@"pageNum"] = @([weakSelf.parameterDic[@"pageNum"] integerValue] + 1);
        [weakSelf apiManagerAll];
    }];
    self.tableView.mj_footer.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[YZProductAppointVC class]]) {
            NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
            [arr removeObject:vc];
            self.navigationController.viewControllers = arr;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_viewCondition removeFromSuperview];
}
- (void)createTitleView {
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 110, 40);
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 110, 25)];
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = @"我的订单";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((110 - 10) / 2, 30, 10, 10)];
    image.image = [UIImage imageNamed:@"show_image"];
    [but addSubview:titleLbl];
    [but addSubview:image];
    self.titleImage = image;
    [but addTarget:self action:@selector(showScreeningAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = but;
}
#pragma mark - request
- (void)apiManagerAll {
    WEAK_SELF;
    [YZHttpApiManager apiMineAppointListWithParameters:self.parameterDic
                                     completionHandler:^(id response, NSError *error) {
                                         [weakSelf.tableView.mj_header endRefreshing];
                                         [weakSelf.tableView.mj_footer endRefreshing];
                                         [YZViewManager viewManagerWithView:weakSelf.tableView
                                                                       data:[response valueForKeyPath:@"data.pageResult.result"]
                                                                      error:error
                                                                      block:^{
                                                                          if ([weakSelf.parameterDic[@"pageNum"] integerValue] == 1) {
                                                                              [weakSelf.arrAppoint removeAllObjects];
                                                                          }                                                                          for (NSDictionary *dic in [response valueForKeyPath:@"data.pageResult.result"]) {
                                                                              [_arrAppoint addObject:[[YZAppointModel alloc] initWithDict:dic]];
                                                                          }
                                                                          [weakSelf.tableView reloadData];
                                          
                                                                          [Utility tableViewFooterHiddenWith:weakSelf.tableView currentPage:[weakSelf.parameterDic[@"pageNum"] integerValue] totalPage:[[response valueForKeyPath:@"data.pageResult.totalPage"] integerValue]];
                                                                      }];
                                     }];
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
    YZAppointModel *appoint = _arrAppoint[indexPath.row];

    YZMineAppointDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"apppoint_detail_vc"];
    WEAK_SELF;
    vc.appointDoneBlock = ^{
        weakSelf.parameterDic[@"pageNum"] = @(1);
        [weakSelf apiManagerAll];
    };
    [vc setAppoint:appoint];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - action
- (void)searchAction {
    YZAppSearchController *vc = [[YZAppSearchController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)actionCondition {
    [self.view endEditing:YES];
    
    if (!_viewCondition) {
        WEAK_SELF;
        _viewCondition = [[YZMineAppointConditionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64.0f)];
    
        _viewCondition.removeSelfBlack = ^{
            [weakSelf.viewCondition removeFromSuperview];
            weakSelf.titleImage.image = [UIImage imageNamed:@"show_image"];
        };
        _viewCondition.conditionHandler = ^(NSDictionary *dic) {
            weakSelf.titleImage.image = [UIImage imageNamed:@"show_image"];
            weakSelf.parameterDic = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNum": @1}];
            if (!dic) {
                [weakSelf apiManagerAll];
                return;
            }
                [weakSelf.parameterDic setObject:dic[dic.allKeys.firstObject] forKey:dic.allKeys.firstObject];
                [weakSelf apiManagerAll];
        };
    }
    [APPDELEGATE.window addSubview:_viewCondition];
}

@end