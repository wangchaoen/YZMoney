//
//  IDCardCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/1.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDCardCellDelegate <NSObject>

- (void)touchIDCardCellDelegateAction:(UIView *)view;
@optional
- (void)IDCardLongtap:(UIView *)view;
@end

@interface IDCardCell : UITableViewCell
@property (nonatomic, strong) UIImageView *positiveImage;
@property (nonatomic, strong) UILabel *positiveLbl;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *backLbl;
@property (nonatomic, assign) id<IDCardCellDelegate> delegate;

@end
