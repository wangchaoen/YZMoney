//
//  FPCertificationVC.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/2.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FPCertificationComeType){
    FPCertificationComeTypeWithNot = 0, //未认证
    FPCertificationComeTypeWithGoing, // 认证中
    FPCertificationComeTypeWithSuccess, // 认证成功
    FPCertificationComeTypeWithFailure // 认证失败
};

@interface FPCertificationVC : UIViewController
@property (nonatomic, assign) FPCertificationComeType comeType;
@end
