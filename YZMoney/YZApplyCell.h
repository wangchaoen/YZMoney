//
//  YZApplyCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZAddressModel.h"

@interface YZApplyCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *phoneNumberLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UIImageView *iconImage;
- (void)sendModelWithModel:(YZAddressModel *)model;
@end
