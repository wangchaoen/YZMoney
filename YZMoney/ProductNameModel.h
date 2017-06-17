//
//  ProductNameModel.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/13.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZJsonBaseModel.h"

@interface ProductNameModel : YZJsonBaseModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) NSInteger type;
@end
