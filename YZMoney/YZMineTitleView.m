//
//  YZMineTitleView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/6.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZMineTitleView.h"
#import "UUImageAvatarBrowser.h"

@interface YZMineTitleView ()
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *lbl;
@end

@implementation YZMineTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 60, 60)];
        titleImage.backgroundColor = [UIColor whiteColor];
        titleImage.layer.cornerRadius = 2;
        titleImage.layer.masksToBounds = YES;
        titleImage.image = [UIImage imageNamed:@"loggedin"];
        [self addSubview:titleImage];
        titleImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showIconImage:)];
        [titleImage addGestureRecognizer:tap];
        self.titleImage = titleImage;
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame) + 10, CGRectGetMinY(titleImage.frame), S_W - CGRectGetMaxX(titleImage.frame) - 50 - 15, 60)];
        lbl.textColor = [UIColor whiteColor];
        [self addSubview:lbl];
        self.lbl = lbl;
        
        UIImageView *more = [[UIImageView alloc]initWithFrame:CGRectMake(S_W - 50, 50, 20, 20)];
        more.image = [UIImage imageNamed:@"more_image"];
        [self addSubview:more];
    }
    return self;
}
- (void)isLogin {
    if (yz_user) {
        self.lbl.text = yz_user.nickname;
        if (!self.lbl.text.length) {
            self.lbl.text = yz_user.hiddenMobile;
        }
        
        if (yz_user.iconImage) {
            self.titleImage.image = yz_user.iconImage;
        }else {
            self.titleImage.image = [UIImage imageNamed:@"loggedin"];
        }
    }
}
- (void)notLogin {
    self.lbl.text = @"登录/注册";
    self.titleImage.image = [UIImage imageNamed:@"notloggedin"];
}
- (void)showIconImage:(UITapGestureRecognizer *)tap {
    if (yz_user.iconImage) {
        [UUImageAvatarBrowser showImage:(UIImageView *)tap.view];
    }
}
@end
