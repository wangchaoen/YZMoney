//
//  YZMineAttachmentController.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/1.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShowType) {
    ShowTypeFirst = 0,
    ShowTypeSecond
};

typedef NS_ENUM (NSInteger, BackType){
    UnKnow,
    idCardFront,
    idCardBack,
    bankCard,
    paymentVoucher,
    accountsPermits,
    businessLicence,
    organizationCodeCertificate,
    corporateCertificate
};
@interface YZMineAttachmentController : UIViewController
@property (nonatomic, assign) ShowType showType;
@property (nonatomic, assign, getter = isSupplement) BOOL supplement;

@property (nonatomic, copy) NSString *idAppoint;
@property (nonatomic, copy) NSArray *imageArr;
@end
