//
//  YZProductDeVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/20.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZProductDeVC.h"
#import "DetailTitleView.h"

@interface YZProductDeVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetailTitleView *titleView;

@property (nonatomic, assign) CGFloat contentOff;
@end

@implementation YZProductDeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentOff = 0;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
  
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, S_W, 20)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, S_W, S_H - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (DetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DetailTitleView alloc]initWithFrame:CGRectMake(0, 20, S_W, 44)];
    }
    return _titleView;
}

- (void)showTitleAnimation {
    WEAK_SELF;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.titleView.frame = CGRectMake(0, 20, S_W, 44);
        weakSelf.tableView.frame = CGRectMake(0, 64, S_W, S_H - 64);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenTitleAnimation {
    WEAK_SELF;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.titleView.frame = CGRectMake(0, -24, S_W, 44);
        weakSelf.tableView.frame = CGRectMake(0, 20, S_W, S_H - 20);
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//        NSIndexPath *path =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
//        NSLog(@"这是第%ld行",path.row);
//    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        [self showTitleAnimation];
        self.contentOff = 0;
        return;
    }
    if (scrollView.contentOffset.y + self.tableView.frame.size.height >= scrollView.contentSize.height) {
        [self hiddenTitleAnimation];
        self.contentOff = scrollView.contentSize.height;
        return;
    }
    if (scrollView.contentOffset.y > self.contentOff) {
        // 向下滑
        [self hiddenTitleAnimation];
    }else {
        // 向上滑
        [self showTitleAnimation];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.contentOff = scrollView.contentOffset.y;
}
@end
