//
//  YZProgressCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZProgressCell.h"

@implementation YZProgressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(27, 18, 14, 14)];
        image.image = [UIImage imageNamed:@"time_icon"];
        [self.contentView addSubview:image];
        
        [self.contentView addSubview:self.timeLbl];
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.titleLbl];
        [self.backView addSubview:self.numberLbl];
        [self.backView addSubview:self.contentLbl];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = YZ_GRAY_COLOR;
    }
    return _lineView;
}
- (UIView *)roundView {
    if (!_roundView) {
        _roundView = [[UIView alloc]initWithFrame:CGRectMake(40, 15, 20, 20)];
        _roundView.backgroundColor = [UIColor whiteColor];
        _roundView.layer.borderColor = RGBColor(132, 176, 221, 1).CGColor;
        _roundView.layer.borderWidth = 1;
        _roundView.layer.cornerRadius = 10;
        _roundView.layer.masksToBounds = YES;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.backgroundColor = RGBColor(203, 152, 32, 1);
        [_roundView addSubview:view];
    }
    return _roundView;
}
- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, S_W - 110, 50)];
        _timeLbl.font = MidFont;
    }
    return _timeLbl;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(_timeLbl.frame), S_W - 50 - 30, 80)];
        _backView.layer.borderColor =  YZ_GRAY_COLOR.CGColor;
        _backView.layer.borderWidth = 1;
    }
    return _backView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 20)];
        _titleLbl.font = MinFont;
        _titleLbl.textColor = YZ_RED_COLOR;
    }
    return _titleLbl;
}

- (UILabel *)numberLbl {
    if (!_numberLbl) {
        _numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLbl.frame), 10, self.backView.frame.size.width - 10 - _titleLbl.frame.size.width, 20)];
        _numberLbl.textColor = YZ_RED_COLOR;
        _numberLbl.font = MinFont;
    }
    return _numberLbl;
}
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc]init];
        _contentLbl.textColor = [UIColor lightGrayColor];
        _contentLbl.numberOfLines = 0;
        _contentLbl.font = MinFont;
    }
    return _contentLbl;
}
+ (CGFloat)returnRowsHeightWithModel:(YZProgressModel *)model {
    NSString *text = model.message;
    CGSize size = [Utility calculatelblSizeForFont:12 scope:CGSizeMake(S_W - 50 - 30 - 20, MAXFLOAT) text:text];
    return  50 + 30 + 10 + size.height + 10 + 5;
}
- (void)sendWithModel:(YZProgressModel *)model {
    self.titleLbl.text = model.title;
    if (model.verifyStatus == 0) {
        self.numberLbl.text = [NSString stringWithFormat:@"申请合同数量：%ld", (long)model.applyCount];
    }else{
        self.numberLbl.text = @"";
    }
    self.timeLbl.text = [YZHelper dateStringFromTimestamp:model.operationDate];
    CGSize size = [Utility calculatelblSizeForFont:12 scope:CGSizeMake(S_W - 50 - 30 - 20, MAXFLOAT) text:model.message];
    self.contentLbl.frame = CGRectMake(CGRectGetMinX(self.titleLbl.frame), CGRectGetMaxY(self.titleLbl.frame) + 5, size.width, size.height);
    self.contentLbl.text = model.message;
    self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, CGRectGetMaxY(self.contentLbl.frame) + 10);
}
@end
