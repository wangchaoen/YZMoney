//
//  YZContractModel.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/2.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZJsonBaseModel.h"

@interface YZContractModel : YZJsonBaseModel
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger applyCount;
@property (nonatomic, assign) NSTimeInterval createDate;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, assign) NSTimeInterval modifyDate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger periodNum;
@property (nonatomic, assign) NSTimeInterval requestTime;
//@property (nonatomic, copy) NSString *ID;
//@property (nonatomic, copy) NSString *creator;
//@property (nonatomic, assign) NSTimeInterval createDate;
//@property (nonatomic, copy) NSString *modifier;
//@property (nonatomic, assign) NSTimeInterval modifyDate;
//@property (nonatomic, copy) NSString *compactName;
//@property (nonatomic, copy) NSString *productId;
//@property (nonatomic, copy) NSString *productCategoryId;
//@property (nonatomic, assign) NSInteger applicableCount;
//@property (nonatomic, assign) NSInteger totalCount;
//@property (nonatomic, assign) NSInteger compactStatus;
//@property (nonatomic, copy) NSString *productSn;
//@property (nonatomic, copy) NSString *productName;
//@property (nonatomic, assign) NSInteger productPeriodNum;
//@property (nonatomic, assign) BOOL valid;
//
//
//@property (nonatomic, copy) NSString *productCompactId;
//@property (nonatomic, assign) NSInteger periodNum;
//@property (nonatomic, assign) NSInteger requestCount;
//@property (nonatomic, copy) NSString *memberId;
//@property (nonatomic, copy) NSDictionary *memberPhone;
//@property (nonatomic, copy) NSString *receiveName;
//@property (nonatomic, copy) NSString *receiveAddress;
//@property (nonatomic, copy) NSDictionary *receivePhone;
//@property (nonatomic, assign) NSTimeInterval requestTime;
//@property (nonatomic, assign) NSInteger verifyStatus;
//@property (nonatomic, copy) NSString *verifyRemark;
//@property (nonatomic, assign)NSTimeInterval verifyTime;

@end
