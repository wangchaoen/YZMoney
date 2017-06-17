//
//  YZMineBut.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/6.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZMineBut.h"

@implementation YZMineBut
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
//        self.imageEdgeInsets = UIEdgeInsetsMake(0, S_W / 4 / 4, 15, 0);

    }
    return self;
}
- (void)createView {
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 20)];
    lbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:lbl];
    lbl.textAlignment = NSTextAlignmentCenter;
    self.lbl = lbl;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 30) / 2, 10, 30, 30)];
    [self addSubview:image];
    self.titleImage = image;
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 20)];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    self.titleLbl.hidden = YES;
    
    
    
//    UILabel *loginLbl = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 70) / 2, self.titleLbl.frame.origin.y - 1, 70, 23)];
//    loginLbl.text = @"登录可见";
//    loginLbl.backgroundColor = YZ_RED_COLOR;
//    loginLbl.textColor = [UIColor whiteColor];
//    loginLbl.textAlignment = NSTextAlignmentCenter;
//    loginLbl.layer.cornerRadius = 4;
//    loginLbl.layer.masksToBounds = YES;
//    loginLbl.font = [UIFont systemFontOfSize:14];
//    [self addSubview:loginLbl];
//    loginLbl.hidden = YES;
//    self.loginLbl = loginLbl;
}
- (void)loginWithArray:(NSArray *)array index:(NSInteger)index{
    self.titleLbl.hidden = NO;
    self.titleImage.hidden = YES;
//    self.loginLbl.hidden = YES;
    if (array.count > index) {
        self.titleLbl.text = array[index];
    }else {
        self.titleLbl.text = @"0";
    }
}


@end
