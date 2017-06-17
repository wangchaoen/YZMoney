//
//  YZClientListVC.h
//  YZMoney
//
//  Created by 7仔 on 15/11/17.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZClientModel.h"





typedef NS_ENUM(NSInteger, YZClientListType) {
    YZClientListTypeProduct,
    YZClientListTypeMine
};


@interface YZClientListVC : UIViewController

@property (nonatomic, assign) YZClientListType type;
@property (nonatomic, strong) void (^selectClientBlock)(YZClientModel *client);

@end
