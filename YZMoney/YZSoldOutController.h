//
//  YZSoldOutController.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/13.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

typedef NS_ENUM(NSInteger, SoldOutComeType) {
    SoldOutComeTypeIndexSearch = 0,
    SoldOutComeTypeLabel
};

#import <UIKit/UIKit.h>

@interface YZSoldOutController : UIViewController
@property (nonatomic, copy) NSString *searchText;
- (instancetype)initWithTitle:(NSString *)title comeType:(SoldOutComeType)type;
@end
