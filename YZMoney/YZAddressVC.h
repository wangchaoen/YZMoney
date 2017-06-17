//
//  YZAddressVC.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZAddressModel;
@protocol YZAddressVCDelegate <NSObject>

- (void)deleteBackWithModel:(YZAddressModel *)model;

@end

@interface YZAddressVC : UIViewController
@property (nonatomic, assign) id<YZAddressVCDelegate> delegate;
@end
