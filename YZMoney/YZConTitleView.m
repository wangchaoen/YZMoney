//
//  YZConTitleView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/11.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZConTitleView.h"

@interface YZConTitleView ()
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation YZConTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        NSArray *array = @[@"可申请", @"我的申请"];
        for (int i = 0; i < array.count; i++) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(i * S_W / 2, 0, S_W / 2, 40);
            [but setTitle:array[i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:14];
            but.tag = i + 1;
            [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:but];
        }
        [self addSubview:self.chooseView];
    }
    return self;
}
- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc]init];
        _chooseView.backgroundColor = YZ_RED_COLOR;
        _chooseView.frame = CGRectMake((S_W / 2 - 60) / 2, 38, 60, 2);
    }
    return _chooseView;
}
- (void)chooseViewScrollWithIndex:(NSInteger)i {
    if (self.currentIndex == i) {
        return;
    }
    UIView *view = [self viewWithTag:i + 1];
    WEAK_SELF;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.chooseView.center = CGPointMake(view.center.x, view.center.y + 19);
    } completion:^(BOOL finished) {
        weakSelf.currentIndex = i;
    }];
}
- (void)butAction:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleViewButActionWithIndex:)]) {
        [self.delegate titleViewButActionWithIndex:but.tag - 1];
    }
}
@end
