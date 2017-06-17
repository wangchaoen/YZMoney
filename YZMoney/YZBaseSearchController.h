//
//  YZBaseSearchController.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/12.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchNavView.h"
#import "SearchHisView.h"

@interface YZBaseSearchController : UIViewController
@property (nonatomic, strong)SearchNavView *searchNavView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)SearchHisView *searchView;

@end
