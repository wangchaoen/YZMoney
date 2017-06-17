//
//  YZSearchLWModel.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/1.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZSearchLWModel.h"

@implementation YZSearchLWModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self._ID = [NSString stringWithFormat:@"%@", value];
    }
}
@end
