//
//  YZAdvertisingView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/9.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZAdvertisingView.h"

@interface YZAdvertisingView ()
@property (nonatomic, assign) NSInteger a;
@property (nonatomic, strong) UIButton *but;
@end

@implementation YZAdvertisingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.a = 3;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-70.0f, 30,50.0f, 30.0f)];
        b.titleLabel.font = MidFont;
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.but = b;
        [b setBackgroundColor:[UIColor lightGrayColor]];
        [b addTarget:self action:@selector(actionSkipAD) forControlEvents:UIControlEventTouchUpInside];
        b.layer.cornerRadius = 6.0f;
        [self addSubview:b];
        [self time];
    }
    return self;
}
- (void)time {
    WEAK_SELF;
    [self.but setTitle:[NSString stringWithFormat:@"跳过%lds", (long)self.a] forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.a--;
        if (weakSelf.a == 0) {
            [weakSelf actionSkipAD];
        }else {
            [weakSelf time];
        }
    });
}
- (void)actionSkipAD {
    WEAK_SELF;
    self.but.hidden = YES;
    [UIView animateWithDuration:2 animations:^{
        weakSelf.frame = CGRectMake(-(S_W / 2), -(S_H / 2), S_W * 2, S_H * 2);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
