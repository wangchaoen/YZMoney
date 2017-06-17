//
//  AutoCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/9.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoCellDelegate <NSObject>
@optional
- (void)deleteHistoryAction;
- (void)touchHistoryAction:(UIButton *)but type:(BOOL)type;
@end

@interface AutoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, assign) id<AutoCellDelegate> delegate;
@property (nonatomic, assign) BOOL type;

- (void)createButForArray:(NSArray *)array;
- (void)createHotArray:(NSArray *)array;
+ (CGFloat) CalculateRowsHeight:(NSArray *)array;
@end
