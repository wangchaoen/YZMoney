
//
//  YZNewsCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/12.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZNewsCell.h"

@implementation YZNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = YZ_GRAY_COLOR;
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, S_W, 80)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        [backView addSubview:self.titleLbl];
        [backView addSubview:self.timeLbl];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, S_W - 10 - 50, 40)];
        _titleLbl.font = [UIFont systemFontOfSize:14];
        _titleLbl.numberOfLines = 2;
    }
    return _titleLbl;
}
- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLbl.frame), S_W - 10 - 50, 20)];
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor lightGrayColor];
    }
    return _timeLbl;
}
@end
