//
//  YZUserModel.h
//  YZMoney
//
//  Created by 7仔 on 15/11/5.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZJsonBaseModel.h"


@interface YZUserModel : YZJsonBaseModel
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *hiddenMobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *hiddenEmail;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *genderView;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *vocation;
@property (nonatomic, copy) NSString *descriptions;
@property (nonatomic, assign) NSInteger verifyStatus;
@property (nonatomic, copy) NSString *verifyStatusView;
@property (nonatomic, assign) NSTimeInterval verifyCommitTime;
@property (nonatomic, copy) NSString *verifyIdentityNo;
@property (nonatomic, copy) NSString *verifyName;
@property (nonatomic, copy) NSString *verifyCompanyName;
@property (nonatomic, copy) NSString *verifyBusinessCard;

#pragma mark - 自己加的
//头像
@property (nonatomic, copy) UIImage *iconImage;

@end
