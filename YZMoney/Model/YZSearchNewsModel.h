//
//  YZSearchNewsModel.h
//  YZMoney
//
//  Created by 7仔 on 15/11/13.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZBaseModel.h"





@interface YZSearchNewsModel : YZBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *docType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSTimeInterval updateTime;

@end
