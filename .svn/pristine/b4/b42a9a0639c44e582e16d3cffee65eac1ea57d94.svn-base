//
//  YZAdderssCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZAdderssCell.h"

@implementation YZAdderssCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = YZ_GRAY_COLOR;
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.nameLbl];
        [self.backView addSubview:self.phoneNumberLbl];
        [self.backView addSubview:self.adderssLbl];
        [self.backView addSubview:self.defaultLbl];
        [self.backView addSubview:self.editorBut];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameLbl.frame) + 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"location_icon"];
        [self.contentView addSubview:imageView];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(S_W - 69, 10, 1, 65 - 20)];
        line1.backgroundColor = YZ_GRAY_COLOR;
        [self.backView addSubview:line1];
    }
    return self;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, S_W - 10, 65)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}
- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
//        _nameLbl.text = @"高传峰";
        _nameLbl.font = MidFont;
    }
    return _nameLbl;
}
- (UILabel *)phoneNumberLbl {
    if (!_phoneNumberLbl) {
        _phoneNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLbl.frame) + 10, 10 ,100, 20)];
//        _phoneNumberLbl.text = @"18641331820";
        _phoneNumberLbl.font = MidFont;
    }
    return _phoneNumberLbl;
}
- (UILabel *)adderssLbl {
    if (!_adderssLbl) {
        _adderssLbl = [[UILabel alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(_phoneNumberLbl.frame), S_W - 15 - 70 - 25, 30)];
        _adderssLbl.font = MinFont;
        _adderssLbl.numberOfLines = 2;
        _adderssLbl.textColor = [UIColor lightGrayColor];
//        _adderssLbl.text = @"辽宁省大连市沙河口区软件园2号2号楼201室";
    }
    return _adderssLbl;
}
- (UIButton *)editorBut {
    if (!_editorBut) {
        _editorBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editorBut setBackgroundImage:[UIImage imageNamed:@"editor_icon"] forState:UIControlStateNormal];
        [_editorBut addTarget:self action:@selector(editorAdderssAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _editorBut.frame = CGRectMake(S_W - 58, 15, 35, 35);
    }
    return _editorBut;
}
- (UILabel *)defaultLbl {
    if (!_defaultLbl) {
        _defaultLbl = [[UILabel alloc]init];
        _defaultLbl.text = @"默认";
        _defaultLbl.font = MinFont;
        _defaultLbl.backgroundColor = YZ_RED_COLOR;
        _defaultLbl.layer.cornerRadius = 2;
        _defaultLbl.layer.masksToBounds = YES;
        _defaultLbl.frame = CGRectMake(CGRectGetMaxX(_phoneNumberLbl.frame), _phoneNumberLbl.frame.origin.y + 2, 30, 16);
        _defaultLbl.textColor = [UIColor whiteColor];
        _defaultLbl.textAlignment = NSTextAlignmentCenter;
        _defaultLbl.hidden = YES;
    }
    return _defaultLbl;
}

- (void)sendAdderssWithModel:(YZAddressModel *)model {
    
}

- (void)editorAdderssAction:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorPeopleAddressWithIndex:)]) {
        [self.delegate editorPeopleAddressWithIndex:but.tag];
    }
}
@end
