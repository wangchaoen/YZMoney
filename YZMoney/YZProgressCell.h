//
//  YZProgressCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZProgressModel.h"

@interface YZProgressCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *numberLbl;
@property (nonatomic, strong) UILabel *contentLbl;
+ (CGFloat)returnRowsHeightWithModel:(YZProgressModel *)model;
- (void)sendWithModel:(YZProgressModel *)model;
@end
