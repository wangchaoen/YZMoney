//
//  YZEdCityCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/27.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZEdCityCell.h"

@implementation YZEdCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 75, 50)];
        
        lbl.text = @"所在地区：";
        lbl.font = MidFont;
        [self.contentView addSubview:lbl];
        [self.contentView addSubview:self.cityLbl];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, S_W, 1)];
        lineView.backgroundColor = YZ_GRAY_COLOR;
        [self.contentView addSubview:lineView];
    }
    return self;
}
- (UILabel *)cityLbl {
    if (!_cityLbl) {
        _cityLbl = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, S_W - 110, 50)];
//        _cityLbl.textColor = [UIColor lightGrayColor];
        _cityLbl.font = MidFont;
//        _cityLbl.text = @"";
    }
    return _cityLbl;
}
@end
