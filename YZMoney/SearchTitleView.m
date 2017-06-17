//
//  SearchTtitleView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/10.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "SearchTitleView.h"

@implementation SearchTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 2
        ;
        self.layer.masksToBounds = true;
        UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(S_W / 3 - 45, 6.5, 17, 17)];
        self.imageView = searchImage;
        [self addSubview:searchImage];
        [self addSubview:self.titlelbl];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapAction:)];
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tap];
        [self changeTopColor];
    }
    return self;
}

- (UILabel *)titlelbl {
    if (!_titlelbl) {
        _titlelbl = [[UILabel alloc]init];
        _titlelbl.font = [UIFont systemFontOfSize:12];
        _titlelbl.frame = CGRectMake(S_W / 3 - 25, 5, self.frame.size.width - 80, 20);
        _titlelbl.text = @"搜索产品名称";
    }
    return _titlelbl;
}
- (void)changeTopColor {
    self.titlelbl.textColor = [UIColor lightGrayColor];
    self.backgroundColor = [UIColor whiteColor];
    self.imageView.image = [UIImage imageNamed:@"search_gray_icon"];
}
- (void)changeUpColor {
    self.titlelbl.textColor = [UIColor blackColor];
    self.backgroundColor = RGBColor(230, 230, 230, 0.7);
    self.imageView.image = [UIImage imageNamed:@"search_icon"];
}

- (void)titleTapAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTitleViewAction)]) {
        [self.delegate searchTitleViewAction];
    }
}
@end