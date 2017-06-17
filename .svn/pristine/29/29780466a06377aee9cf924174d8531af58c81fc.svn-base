//
//  YZAdderssCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZAddressModel.h"

@protocol YZAdderssCellDelegate <NSObject>

- (void)editorPeopleAddressWithIndex:(NSInteger)index;

@end

@interface YZAdderssCell : UITableViewCell
@property (nonatomic, assign) id<YZAdderssCellDelegate> delegate;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *phoneNumberLbl;
@property (nonatomic, strong) UILabel *adderssLbl;
@property (nonatomic, strong) UILabel *defaultLbl;
@property (nonatomic, strong) UIButton *editorBut;
- (void)sendAdderssWithModel:(YZAddressModel *)model;
@end
