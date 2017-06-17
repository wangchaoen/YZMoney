//
//  YZContractCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZContractCell.h"

@implementation YZContractCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = YZ_GRAY_COLOR;
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.contentLbl];
        [self.backView addSubview:self.numberLbl];
        [self.backView addSubview:self.detailsBut];
        [self.backView addSubview:self.dateLbl];
    }
    return self;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, S_W, 90)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, S_W - 10 - 110, 60)];
        _contentLbl.numberOfLines = 2;
        _contentLbl.font = MidFont;
//        _contentLbl.text = @"但简单点卡仓库门口那才叫做可能大大没看到";
    }
    return _contentLbl;
}
- (UILabel *)numberLbl {
    if (!_numberLbl) {
        _numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_contentLbl.frame), 110, 20)];
        _numberLbl.font = MinFont;
        _numberLbl.textColor = [UIColor lightGrayColor];
//        _numberLbl.text = @"合同数量:100";
    }
    return _numberLbl;
}
- (UILabel *)dateLbl {
    if (!_dateLbl) {
        _dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numberLbl.frame), CGRectGetMinY(_numberLbl.frame), 150, 20)];
        _dateLbl.textColor = [UIColor lightGrayColor];
//        _dateLbl.text = @"2017年12月31日10点12分";
        _dateLbl.font = MinFont;
    }
    return _dateLbl;
}
- (UIButton *)detailsBut {
    if (!_detailsBut) {
        _detailsBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailsBut.frame = CGRectMake(S_W - 90, (self.backView.frame.size.height - 30) / 2, 70, 30);
        _detailsBut.backgroundColor = YZ_RED_COLOR;
        [_detailsBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _detailsBut.titleLabel.font = MidFont;
        _detailsBut.layer.cornerRadius = 4;
        _detailsBut.layer.masksToBounds = YES;
        [_detailsBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_detailsBut setTitle:@"查看进度" forState:UIControlStateNormal];
    }
    return _detailsBut;
}
- (void)sendWithModel:(YZContractModel *)model index:(NSInteger)index{
    self.detailsBut.tag = index;
    if (model.type == 0) {
        
        [self.detailsBut setTitle:@"申请合同" forState:UIControlStateNormal];
        self.contentLbl.text = model.name;
        self.dateLbl.hidden = YES;

        self.numberLbl.text = [NSString stringWithFormat:@"可申请合同数：%ld", (long)model.periodNum];
        self.numberLbl.frame = CGRectMake(10, CGRectGetMaxY(_contentLbl.frame), 150, 20);
    }else {
        self.numberLbl.frame = CGRectMake(10, CGRectGetMaxY(_contentLbl.frame), 110, 20);
        self.dateLbl.hidden = NO;
        self.dateLbl.text = [YZHelper dateStringFromTimestamp:model.createDate];
        self.contentLbl.text = model.name;
        self.numberLbl.text = [NSString stringWithFormat:@"申请数：%ld", (long)model.applyCount];
        [self.detailsBut setTitle:@"查看进度" forState:UIControlStateNormal];
    }
    
}
- (void)butAction:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(butClickActionWithCell:but:)]) {
        [self.delegate butClickActionWithCell:self but:but];
    }
}
@end
