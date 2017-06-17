//
//  YZEdDetailCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/27.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZEdDetailCell.h"

@implementation YZEdDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 75, 50)];
        
        lbl.text = @"详细地址：";
        lbl.font = MidFont;
        self.nameLbl = lbl;
        [self.contentView addSubview:lbl];
        [self.contentView addSubview:self.textField];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, S_W, 1)];
        lineView.backgroundColor = YZ_GRAY_COLOR;
        [self.contentView addSubview:lineView];
    }
    return self;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, S_W - 90, 50)];
        _textField.placeholder = @"详细地址";
        _textField.font = MidFont;
    }
    return _textField;
}

@end
