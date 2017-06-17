//
//  YZNewsVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/11.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZNewsVC.h"
#import "YZNewsSV.h"
#import "YZNewsDetailVC.h"
#import "YZSearchVC.h"
#import "YZTitleScrollView.h"
#import "YZNewsSearchVC.h"
#import "ProductNameModel.h"

@interface YZNewsVC () <YZTitleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet YZTitleScrollView *svNewsCate;
@property (weak, nonatomic) IBOutlet YZNewsSV *svNewsList;

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) NSMutableArray *arrNewsCate;

@end





@implementation YZNewsVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"index_dock" label:@"/infor"];

//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrNewsCate = [NSMutableArray array];
    [self createSearchAndScreenAction];
    self.svNewsCate.viewDelegate = self;
    
    [YZHttpApiManager apiNewsCategoryWithParameters:nil
                                  completionHandler:^(id response, NSError *error) {
                                      if ([response[@"success"] boolValue]) {
                                          NSDictionary *data = response[@"data"];
                                          NSArray *tabList = data[@"tabList"];
                                          for (NSDictionary *dic in tabList) {
                                              ProductNameModel *model = [[ProductNameModel alloc]initWithDict:dic];
                                    [_arrNewsCate addObject:model];
                                          }
                                          [YZCacheHelper cacheObject:_arrNewsCate file:@"news_category"];
                                      }
                                      else {
                                          _arrNewsCate = [YZCacheHelper objectCachedWithFile:@"news_category"];
                                      }
                                      
                                      [_svNewsCate createViewWithArray:_arrNewsCate];
                                      
                                      _svNewsList.vc = self;
                                      _svNewsList.arrCategory = _arrNewsCate;
                                      _svNewsList.backgroundViewAnimationBlock = ^void(float offset){
                                          [_svNewsCate slidingActionWith:offset scrollView:_svNewsList];
                                      };
                                  }];
}

- (void)createSearchAndScreenAction {
    UIView *backTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 60)];
    backTitleView.backgroundColor = YZ_RED_COLOR;
    backTitleView.userInteractionEnabled = YES;
    [self.view addSubview:backTitleView];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, S_W, 40)];
    lbl.font = BigFont;
    lbl.text = @"资讯";
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    [backTitleView addSubview:lbl];
//    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
//    [search setTitle:@"搜索" forState:UIControlStateNormal];
//    [search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    search.frame = CGRectMake(10, 20 + 5, S_W - 20, 30);
//    search.titleLabel.font = [UIFont systemFontOfSize:14];
//    [search setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
//    [search setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
//    [search setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
//    search.layer.cornerRadius = 2;
//    search.layer.masksToBounds = YES;
//    search.backgroundColor = [UIColor whiteColor];
//    [search addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    [backTitleView addSubview:search];
    
    
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame = CGRectMake(S_W - 110, 49 + 20 + 5, 100, 30);
//    [but setTitle:@"筛选" forState:UIControlStateNormal];
//    [but setTitleColor:YZ_BLUE_COLOR forState:UIControlStateNormal];
//    [but addTarget:self action:@selector(actionCondition) forControlEvents:UIControlEventTouchUpInside];
//    
//    but.titleLabel.font = [UIFont systemFontOfSize:14];
//    [but setImage:[UIImage imageNamed:@"small_blue_sreen"] forState:UIControlStateNormal];
//    [self.view addSubview:but];
}



#pragma mark - product category
- (void)clickCategoryWithSenderDelegate:(UIButton *)but {
    [_svNewsList setContentOffset:CGPointMake(CGRectGetWidth(_svNewsList.frame)*but.tag, 0.0f) animated:YES];
    ProductNameModel *model = _arrNewsCate[but.tag];
    [MobClick event:@"product_fenlei" label:model.name];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_news_detail"]) {
        [(YZNewsDetailVC *)segue.destinationViewController setIdNews:[sender ID]];
        [(YZNewsDetailVC *)segue.destinationViewController setTitle:[sender title]];
    }
}

#pragma mark - action
- (void)searchAction {
    YZNewsSearchVC *vc = [[YZNewsSearchVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)actionCondition {
    
}
@end
