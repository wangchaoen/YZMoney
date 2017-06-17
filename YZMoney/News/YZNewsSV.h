//
//  YZNewsSV.h
//  YZMoney
//
//  Created by 7仔 on 15/11/11.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface YZNewsSV : UIScrollView

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) NSArray *arrCategory;
@property (nonatomic, strong) void(^backgroundViewAnimationBlock)(float offset);

@end
