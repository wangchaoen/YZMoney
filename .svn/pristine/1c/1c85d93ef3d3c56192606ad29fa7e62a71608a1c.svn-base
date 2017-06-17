//
//  NoDataView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/19.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata.png"]];
        iv.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-60.0f);
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(iv.frame)+10.0f, CGRectGetWidth(self.bounds), 20.0f)];
        l.textAlignment = NSTextAlignmentCenter;
            if (title) {
                l.text = title;
            }else {
                l.text = @"暂无数据";
            }
        l.textColor = RGBColor(159.0f, 159.0f, 159.0f, 1.0f);
        [self addSubview:iv];
        [self addSubview:l];
    }
    return self;
}
@end
