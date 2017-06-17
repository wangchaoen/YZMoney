//
//  YZNewsSearchCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/12.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZSearchNewsModel;

@interface YZNewsSearchCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *dateLbl;
- (void)sendModelWith:(YZSearchNewsModel *)news;
@end
