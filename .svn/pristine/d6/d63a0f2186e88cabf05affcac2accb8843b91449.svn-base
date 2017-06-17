//
//  LblChooseCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/9.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LblChooseCellDelegate <NSObject>

- (void)chooseButAction:(UIButton *)but;
@end

@interface LblChooseCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, assign) id<LblChooseCellDelegate> delegate;

- (void)createViewForArray:(NSArray *)array;
@end
