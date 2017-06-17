//
//  ProgressView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/21.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatView];
    }
    return self;
}
- (void)creatView  {
    [self addSubview:self.lineView];
    [self.lineView addSubview:self.headView];
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 3.5, 0, 3)];
        _lineView.backgroundColor = RGBColor(234, 206, 143, 1);
    }
    return _lineView;
}
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = RGBColor(234, 206, 143, 1);
        _headView.layer.cornerRadius = 4.5;
        _headView.layer.masksToBounds = YES;
        _headView.frame = CGRectMake(_lineView.frame.size.width - 9, -3.5, 9, 9);
    }
    return _headView;
}
- (void)progressZero {
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 3.5, 0, 3)];
    self.headView.frame = CGRectMake(_lineView.frame.size.width - 9, -3.5, 9, 9);
}
- (void)setProgressWithNumber:(CGFloat)number {
    if (number > 1) {
        number = 1;
    }else if (number < 0) {
        number = 0;
    }
    CGFloat maxW = S_W - 20;
    CGFloat viewW = maxW * number;
    WEAK_SELF;
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.lineView.frame = CGRectMake(10, 3.5, viewW, 2);
        weakSelf.headView.frame = CGRectMake(weakSelf.lineView.frame.size.width - 9, -3.5, 9, 9);
    } completion:^(BOOL finished) {
        
    }];
    
}
@end
