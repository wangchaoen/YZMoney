//
//  YZAddressModel.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/2.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZAddressModel.h"

@implementation YZAddressModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"receivePhone": @"receivePhone.value", @"ID": @"id"}];
}

@end
