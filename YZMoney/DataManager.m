//
//  DataManager.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/2/27.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "DataManager.h"


static DataManager *manager = nil;

@implementation DataManager

+ (DataManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[DataManager alloc]init];
            manager.productDic =
            [NSMutableDictionary dictionary];
        }
    });
    return manager;
}
@end
