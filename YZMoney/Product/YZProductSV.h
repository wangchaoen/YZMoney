//
//  YZProductSV.h
//  YZMoney
//
//  Created by 7仔 on 15/11/10.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface YZProductSV : UIScrollView

@property (nonatomic, assign) UIViewController *vc;
@property (nonatomic, strong) NSArray *arrCategory;
@property (nonatomic, strong) void(^backgroundViewAnimationBlock)(float offset);

- (void)loadListWithParameters:(id)parameters refresh:(BOOL)refresh page:(BOOL)page filter:(BOOL)filter;

@end
