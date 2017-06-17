//
//  YZAddressModel.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/2.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZJsonBaseModel.h"

@interface YZAddressModel : YZJsonBaseModel
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSTimeInterval createDate;
@property (nonatomic, assign) NSTimeInterval modifyDate;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *receivePhone;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *receiveAddress;
@property (nonatomic, assign) BOOL isDefault;
@end
