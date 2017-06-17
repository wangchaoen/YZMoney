//
//  SreenController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/16.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "SreenController.h"
#import "YZProductFilterTV.h"

@interface SreenController ()

@end

@implementation SreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, S_H / 7, S_W, S_H - S_H / 7)];
    backView.backgroundColor = YZ_GRAY_COLOR;
    [self.view addSubview:backView];
    YZProductFilterTV *pfv = [[YZProductFilterTV alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame)) style:UITableViewStylePlain data:@[]];
    [backView addSubview:pfv.viewVisual];
    self.pfv = pfv;
    WEAK_SELF;
    pfv.determineBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}
- (void)showListType:(NSString *)type array:(NSArray *)array{
        self.pfv.typeName = type;
    self.pfv.arrCondition = array;
    [self.pfv reloadData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
