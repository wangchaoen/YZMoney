//
//  IDCardCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/1.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "IDCardCell.h"

@implementation IDCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *array = @[@"身份证正面", @"身份证反面"];
//        CGFloat interval = 15;
//        CGFloat width = (S_W - interval * 3) / 2;
//        CGFloat height = width / 8 * 5;
        CGFloat interval = (S_W - 110 * 2) / 3;
        CGFloat width = 110;
        CGFloat height = 110;
        
        for (int i = 0; i < 2; i++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(interval + (width + interval) * i, 40, width, height)];
            image.contentMode = UIViewContentModeScaleAspectFit;
            image.userInteractionEnabled = true;
            image.tag = i;
            [self.contentView addSubview:image];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtapAction:)];
            longTap.minimumPressDuration = 1;
            [image addGestureRecognizer:longTap];
            
            [image addGestureRecognizer:tap];
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_00%d.png", i + 1]];
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(image.frame), 5, S_W / 2 - 15, 20)];
            lbl.text = array[i];
            lbl.font = MidFont;
            [self.contentView addSubview:lbl];
            
            if (i == 0) {
                self.positiveImage = image;
                self.positiveLbl = lbl;
            }else {
                self.backImage = image;
                self.backLbl = lbl;
            }
        }
    }
    return self;
}
- (void)tapViewAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchIDCardCellDelegateAction:)]) {
        [self.delegate touchIDCardCellDelegateAction:tap.view];
    }
}
- (void)longtapAction:(UILongPressGestureRecognizer *)longTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(IDCardLongtap:)]) {
        [self.delegate IDCardLongtap:longTap.view];
    }
}

@end
