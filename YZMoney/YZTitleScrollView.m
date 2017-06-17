//
//  YZTitleScrollView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/24.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZTitleScrollView.h"


@implementation YZTitleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)createViewWithArray:(NSArray<ProductNameModel *> *)array {
    for (NSInteger i=0; i < array.count; i++) {
        ProductNameModel *model = array[i];
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(100 * i, 0.0, 100, 49)];
        but.tag = i;
        [but addTarget:self action:@selector(clickCategoryWithSender:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100.0f*i, 0.0f, 100.0f, 49.0f)];
        b.tag = i;
        [b setTitle:model.name forState:UIControlStateNormal];
        [b.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self addSubview:b];
//        CAGradientLayer* gradientLayer = [CAGradientLayer layer];
//        gradientLayer.frame = b.frame;
//        gradientLayer.colors =  @[(id)[UIColor grayColor].CGColor, (id)[UIColor clearColor].CGColor];
//        gradientLayer.startPoint = CGPointMake(0, 1);
//        gradientLayer.endPoint = CGPointMake(1, 1);
//        [self.layer addSublayer:gradientLayer];
//        
//        gradientLayer.mask = b.layer;
//        b.frame = gradientLayer.bounds;
        [self addSubview:but];
    }
    self.contentSize = CGSizeMake(100.0f * array.count, CGRectGetHeight(self.frame));
    
    
    self.slidingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.frame)-20.0f - 2, 80.0f, 2)];
    self.slidingView.center = CGPointMake(50.0f, 48.0f);
    self.slidingView.backgroundColor = YZ_RED_COLOR;
//    self.slidingView.layer.cornerRadius = 6.0f;
//    self.slidingView.clipsToBounds = YES;
    [self addSubview:self.slidingView];
    
    for (NSInteger i=0; i < array.count; i++) {
        ProductNameModel *model = array[i];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100.0f*i-10.0f, -10.0f, 100.0f, 49.0f)];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14.0f];
        l.textColor = [UIColor whiteColor];
        l.text = model.name;
        l.tag = i;
        [self.slidingView addSubview:l];
    }
}
- (void)slidingActionWith:(CGFloat)offset scrollView:(UIScrollView *)scrollView {
    if (offset == 0) {
        return;
    }
    self.slidingView.center = CGPointMake(offset*(100.0f/CGRectGetWidth(scrollView.frame))+50.0f, 48);
    
    for (UILabel *l in self.slidingView.subviews) {
        l.frame = CGRectMake(-offset*(100.0f/S_W)+100.0f*l.tag-10.0f, -10.0f, 100.0f, 49.0f);
    }
    if (self.contentSize.width > CGRectGetWidth(self.frame)) {
        if (((scrollView.contentOffset.x / S_W)  + 1) * 100 - 50 - S_W / 2 + S_W>= self.contentSize.width) {
            [self setContentOffset:CGPointMake(self.contentSize.width - S_W, 0) animated:YES];          return;
        }
        if (self.slidingView.center.x > S_W / 2) {
            [self setContentOffset:CGPointMake(((scrollView.contentOffset.x / S_W)  + 1) * 100 - 50 - S_W / 2, 0) animated:YES];
        }else {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void)clickCategoryWithSender:(UIButton *)but {
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(clickCategoryWithSenderDelegate:)]) {
        [self.viewDelegate clickCategoryWithSenderDelegate:but];
    }
}
@end
