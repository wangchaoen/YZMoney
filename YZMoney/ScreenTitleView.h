//
//  ScreenTitlwView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/13.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductNameModel;

@protocol ScreenTitleViewDelegate <NSObject>

- (void)productButAction:(ProductNameModel *)model index:(NSInteger)index;

@end

@interface ScreenTitleView : UIView
@property (nonatomic, assign)id<ScreenTitleViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *titleArr;
- (void)creatProductBut:(NSArray *)array;
@end
