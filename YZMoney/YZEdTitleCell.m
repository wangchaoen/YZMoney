//
//  YZEdTitleCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/27.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZEdTitleCell.h"

@implementation YZEdTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *array = @[@"收件人:", @"手机号:"];
        for (int i = 0; i < 2; i++) {
            UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 50 * i, 65, 50)];
            titleLbl.font = MidFont;
    
            titleLbl.text = array[i];
            [self.contentView addSubview:titleLbl];
            
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLbl.frame), CGRectGetMinY(titleLbl.frame) * i, S_W - CGRectGetMaxX(titleLbl.frame) - 100, 50)];
            textField.font = MidFont;
            textField.placeholder = @"点击输入";
            [self.contentView addSubview:textField];
            if (i == 0) {
                self.nameTF = textField;
            }else {
                self.numberTF = textField;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 * (i + 1), S_W - (i == 0 ? 100 : 0), 1)];
                lineView.backgroundColor = YZ_GRAY_COLOR;
                [self.contentView addSubview:lineView];
            
        }
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(S_W - 100, 0, 100, 100);
        but.titleLabel.font = MidFont;
        but.titleEdgeInsets = UIEdgeInsetsMake(45, -33, 0, 0);
        but.imageEdgeInsets = UIEdgeInsetsMake(-20, 25, 0, 0);
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitle:@"选联系人" forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"contact_icon"] forState:UIControlStateNormal];
        [self.contentView addSubview:but];
        [but addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(S_W - 100, 0, 1, 100)];
        line.backgroundColor = YZ_GRAY_COLOR;
        [self.contentView addSubview:line];
        
    }
    return self;
}
- (void)addContactAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addContactClick)]) {
        [self.delegate addContactClick];
    }
}

@end
