//
//  YZClientEditVC.h
//  YZMoney
//
//  Created by 7仔 on 15/11/17.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZClientModel.h"





@interface YZClientEditVC : UIViewController

@property (nonatomic, strong) void (^submitClientBlock)(void);
@property (nonatomic, strong) YZClientModel *client;
@property (nonatomic, strong) NSArray *arrTypePersonIdentify;
@property (nonatomic, strong) NSArray *arrTypeOrgIdentify;

@end
