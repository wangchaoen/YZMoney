//
//  YZAppointModel.h
//  YZMoney
//
//  Created by 7仔 on 15/11/18.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZJsonBaseModel.h"


@interface YZAppointModel : YZJsonBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *customerEmail;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *expectedRate;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productTerm;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *sn;

@property (nonatomic, strong) NSNumber *commissionRate;
@property (nonatomic, assign) NSInteger bookingStatus;
@property (nonatomic, assign) NSInteger commissionAmount;
@property (nonatomic, assign) NSInteger commissionStatus;
@property (nonatomic, assign) NSInteger customerType;
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, assign) NSInteger payAmount;
@property (nonatomic, assign) NSInteger subscribeAmount;
@property (nonatomic, assign) NSInteger chanBalanceStatus;
@property (nonatomic, assign) NSInteger empBalanceStatus;
@property (nonatomic, assign) NSTimeInterval bookingTime;
@property (nonatomic, assign) NSTimeInterval commissionDate;
@property (nonatomic, assign) NSTimeInterval createDate;
@property (nonatomic, assign) NSTimeInterval modifyDate;
@property (nonatomic, assign) NSTimeInterval orderTime;
@property (nonatomic, assign) NSTimeInterval payEndTime;

@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *customerPhone;
@property (nonatomic, strong) NSString *identifyNo;
@property (nonatomic, copy) NSString *fundManager;
@end