//
//  YZProgressModel.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/3.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZProgressModel : YZBaseModel
@property (nonatomic, copy) NSString *compactId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSTimeInterval operationDate;
@property (nonatomic, assign) NSInteger applyCount;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger verifyStatus;
@property (nonatomic, copy) NSString *ID;
@end
