//
//  YZContractCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZContractModel.h"
@class YZContractCell;

@protocol YZContractCellDelegate <NSObject>

- (void)butClickActionWithCell:(YZContractCell *)cell but:(UIButton *)but;

@end

@interface YZContractCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *numberLbl;

@property (nonatomic, strong) UILabel *dateLbl;
@property (nonatomic, strong) UIButton *detailsBut;
@property (nonatomic, assign) id<YZContractCellDelegate> delegate;
- (void)sendWithModel:(YZContractModel *)model index:(NSInteger)index;
@end