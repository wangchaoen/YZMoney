//
//  AutoCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/9.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "AutoCell.h"
#import "SearchHisModel.h"

@implementation AutoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLbl];
//        self.titleLbl.text = @"历史记录";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame) + 3, S_W, 0.4)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    return self;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 130, 30)];
        _titleLbl.font = [UIFont systemFontOfSize:16];
    }
    return _titleLbl;
}
- (void)createButForArray:(NSArray *)array {
    [self creatViewUtils:array showDeleteHistory:YES];
}


- (void)createHotArray:(NSArray *)array {
    [self creatViewUtils:array showDeleteHistory:NO];
}
- (void)creatViewUtils:(NSArray *)array showDeleteHistory:(BOOL)isDelete {
    self.type = isDelete;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    if (isDelete) {
        UIButton *deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBut setTitle:@"删除历史记录" forState:UIControlStateNormal];
        [deleteBut setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        deleteBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteBut addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteBut.titleLabel.textAlignment = NSTextAlignmentRight;
        [deleteBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        deleteBut.frame = CGRectMake(S_W - 140, 20, 130, 30);
        deleteBut.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
        [self.contentView addSubview:deleteBut];
    }
    
    CGFloat upInterval = 5;
    CGFloat BF = 10;
    CGFloat interval = 10;
    NSInteger rows = 0;
    CGFloat beforeWith = BF;
    CGFloat width = S_W - BF *2;
    
    NSInteger i = 0;
    for (SearchHisModel *model in array) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        but.tag = i;
        [but addTarget:self action:@selector(butActon:) forControlEvents:UIControlEventTouchUpInside];
        but.layer.cornerRadius = 2;
        but.layer.masksToBounds = true;
        [but setTitle:model.searchText forState:UIControlStateNormal];
        [but setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [but setBackgroundColor:RGBColor(237, 237, 237, 1)];
        
        CGSize timeSize = [Utility calculatelblSizeForFont:14 scope:CGSizeMake(MAXFLOAT, 20) text:model.searchText];
        timeSize.width += 15;
        if (timeSize.width > width) {
            timeSize.width = width - 5;
        }
        if ((width - beforeWith < timeSize.width) && (beforeWith != BF)) {
            rows += 1;
            beforeWith = BF;
        }
        but.frame = CGRectMake(beforeWith, upInterval + CGRectGetMaxY(self.titleLbl.frame) + 10 + rows * (25 + upInterval), timeSize.width + 5, 25);
        
        beforeWith = beforeWith + but.frame.size.width + interval;
        [self.contentView addSubview:but];
        i++;
    }
}

+ (CGFloat) CalculateRowsHeight:(NSArray *)array {
    CGFloat titleLblH = 65;
    CGFloat BF = 10;
    CGFloat interval = 10;
    CGFloat upInterval = 5;
    NSInteger rows = 0;
    CGFloat beforeWith = BF;
    CGFloat width = S_W - BF *2;
    for (SearchHisModel *model in array) {
        CGSize timeSize = [Utility calculatelblSizeForFont:14 scope:CGSizeMake(MAXFLOAT, 20) text:model.searchText];
        timeSize.width += 15;
        if (timeSize.width > width) {
            timeSize.width = width;
        }
        if ((width - beforeWith < timeSize.width) && (beforeWith != BF)) {
            rows += 1;
            beforeWith = BF;
        }
        
        beforeWith = beforeWith + timeSize.width + 5 + interval;
    }
    return 10 + (rows + 1) * (25 + upInterval) + titleLblH;
}

#pragma mark - action
- (void)deleteAction:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHistoryAction)]) {
        [self.delegate deleteHistoryAction];
    }
}
- (void)butActon:(UIButton *)but {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchHistoryAction: type:)]) {
        [self.delegate touchHistoryAction:but type:self.type];
    }
}
@end
