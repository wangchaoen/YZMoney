//
//  YZProductDetailVC.h
//  YZMoney
//
//  Created by 7仔 on 15/11/9.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZProductModel.h"
#import "YZADModel.h"




@interface YZProductDetailVC : UIViewController

//必须传 2选一
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *idProduct;
//必须传
@property (nonatomic, copy) NSString *column;

//是否是专题
@property (nonatomic, assign, getter=isProjectVC) BOOL projectVC;
@property (nonatomic, strong) YZADModel *model;
//h5打开app
@property (nonatomic, copy) NSString *docId;
@end
