//
//  YZUserModel.m
//  YZMoney
//
//  Created by 7仔 on 15/11/5.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZUserModel.h"





@implementation YZUserModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"descriptions": @"description"}];
}

@end