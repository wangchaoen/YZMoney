//
//  YZContractController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/11.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZContractController.h"
#import "YZContractView.h"
#import "YZConTitleView.h"
#import "YZApplyVC.h"
#import "YZProgressVC.h"
#import "YZContractModel.h"

@interface YZContractController () <YZConTitleViewDelegate, YZContractViewDelegate, YZApplyVCDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong)YZConTitleView *titleView;
@property (nonatomic, strong) YZContractView *contentView;
@end

@implementation YZContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"合同申请";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    
    UISearchBar *searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, S_W, 30)];
    self.searchBar = searchbar;
    searchbar.delegate = self;
    searchbar.placeholder = @"搜索产品名称";
    self.navigationItem.titleView = searchbar;
    
    UIBarButtonItem *barBut = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = barBut;
    
    UIView *putView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 40)];
    putView.backgroundColor = RGBColor(245, 245, 245, 1);
    self.searchBar.inputAccessoryView = putView;
    UIButton *reBut = [UIButton buttonWithType:UIButtonTypeCustom];
    reBut.titleLabel.font = BigFont;
    [reBut setTitle:@"完成" forState:UIControlStateNormal];
    [reBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reBut.frame = CGRectMake(S_W - 60, 0, 60, 40);
    [reBut addTarget:self action:@selector(puckUpKeyBoardAction) forControlEvents:UIControlEventTouchUpInside];
    [putView addSubview:reBut];
}
- (YZConTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[YZConTitleView alloc]initWithFrame:CGRectMake(0, 64, S_W, 40)];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.delegate = self;
    }
    return _titleView;
}
- (YZContractView *)contentView {
    if (!_contentView) {
        _contentView = [[YZContractView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), S_W, S_H - 40 - 64)];
        _contentView.viewDelegate = self;
    }   
    return _contentView;
}
#pragma mark - searchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchAction];
}
#pragma mark - customDelegate
// titleViewDelegate
- (void)titleViewButActionWithIndex:(NSInteger)index {
    [self puckUpKeyBoardAction];
    [self.contentView setContentOffset:CGPointMake(index * S_W, 0) animated:YES];
}
// contentViewDelegate
- (void)clickTableCellAction {
    [self puckUpKeyBoardAction];
    
}
- (void)clickButCellActionWithModel:(YZContractModel *)model {
    [self puckUpKeyBoardAction];
    if (model.type == 0) {
        YZApplyVC *vc = [[YZApplyVC alloc]init];
        vc.contractMD = model;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    YZProgressVC *vc = [[YZProgressVC alloc]init];
    vc.applyCompactId = model.ID;
    [self.navigationController pushViewController:vc animated:YES]; 
}
- (void)scrollViewDidEndScroll {
    self.searchBar.text = @"";
    NSInteger i = self.contentView.contentOffset.x / S_W;
    [self.titleView chooseViewScrollWithIndex:i];
}
//提交成功
- (void)applySuccessClick {
//    [self.contentView setContentOffset:CGPointMake(S_W, 0) animated:YES];
//    [self.contentView requestWithCurrentPage:1];
}
#pragma mark - action
//搜索
- (void)searchAction {
    [self.contentView searchActionWithText:self.searchBar.text];
}
//回收键盘
- (void)puckUpKeyBoardAction {
    [self.searchBar resignFirstResponder];
}
@end
