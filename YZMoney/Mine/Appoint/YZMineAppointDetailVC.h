//
//  YZMineAppointDetailVC.h
//  YZMoney
//
//  Created by 7仔 on 15/11/18.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZAppointModel.h"





@interface YZMineAppointDetailVC : UIViewController

@property (nonatomic, strong) YZAppointModel *appoint;
@property (nonatomic, strong) void (^appointDoneBlock)(void);

@end
