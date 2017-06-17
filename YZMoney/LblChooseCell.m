//
//  LblChooseCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/9.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "LblChooseCell.h"
#import "SearchHisModel.h"

@implementation LblChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLbl];
        self.titleLbl.text = @"热搜标签";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame) + 3, S_W, 0.4)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];

    }
    return self;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, S_W - 10, 30)];
        _titleLbl.font = [UIFont systemFontOfSize:16];
    }
    return _titleLbl;
}

- (void)createViewForArray:(NSArray *)array {
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat interval = 10;
    CGFloat upInterval = 5;
    CGFloat width = (S_W - 10 * 4) / 3;
    for (NSInteger i = 0; i < array.count; i++) {
         SearchHisModel *model = array[i];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = i;
        but.layer.cornerRadius = 4;
        but.layer.masksToBounds = true;
        [but setTitle:model.searchText forState:UIControlStateNormal];
        [but setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [but setBackgroundColor:RGBColor(237, 237, 237, 1)];
        [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        but.frame = CGRectMake(interval + (width + interval) * (i % 3), upInterval+ CGRectGetMaxY(self.titleLbl.frame) + 10 + (25 + upInterval) * (i / 3), width, 25);
        
        [self.contentView addSubview:but];
    }
}
- (void)butAction:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseButAction:)]) {
        [self.delegate chooseButAction:but];
    }
}
@end
