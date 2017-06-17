//
//  YZNewsSearchCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/12.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZNewsSearchCell.h"
#import "YZSearchNewsModel.h"

@implementation YZNewsSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.typeLbl];
        [self.contentView addSubview:self.dateLbl];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.frame = CGRectMake(10, 5, S_W - 15, 20);
        _titleLbl.font = [UIFont systemFontOfSize:14];
    }
    return  _titleLbl;
}
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc]init];
        _contentLbl.frame = CGRectMake(10, CGRectGetMaxY(_titleLbl.frame), S_W - 15, 40);
        _contentLbl.font = [UIFont systemFontOfSize:12];
        _contentLbl.numberOfLines = 2;
    }
    return _contentLbl;
}
- (UILabel *)typeLbl {
    if (!_typeLbl) {
        _typeLbl = [[UILabel alloc]init];
        _typeLbl.text = @"资讯";
        _typeLbl.frame = CGRectMake(10, CGRectGetMaxY(_contentLbl.frame), 50, 20);
        _typeLbl.font = [UIFont systemFontOfSize:10];
        _typeLbl.textColor = [UIColor lightGrayColor];
    }
    return _typeLbl;
}
- (UILabel *)dateLbl {
    if (!_dateLbl) {
        _dateLbl = [[UILabel alloc]init];
        _dateLbl.frame = CGRectMake(CGRectGetMaxX(_typeLbl.frame), CGRectGetMaxY(_contentLbl.frame), 130, 20);
        _dateLbl.font = [UIFont systemFontOfSize:10];
        _dateLbl.textColor = [UIColor lightGrayColor];
    }
    return _dateLbl;
}
- (void)sendModelWith:(YZSearchNewsModel *)news{
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithData:[news.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil                                                 error:nil];
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0f] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, title.length)];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[news.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, content.length)];
    [content addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, content.length)];
    self.titleLbl.attributedText = title;
    self.contentLbl.attributedText = content;
    self.dateLbl.text = [YZHelper dateStringFromTimestamp:news.updateTime];
}
@end
