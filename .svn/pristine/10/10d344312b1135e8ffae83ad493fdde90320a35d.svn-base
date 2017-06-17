//
//  YZTitleScrollView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/24.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductNameModel.h"

@protocol YZTitleScrollViewDelegate <NSObject>

- (void)clickCategoryWithSenderDelegate:(UIButton *)but;

@end

@interface YZTitleScrollView : UIScrollView
@property (nonatomic, strong) UIView *slidingView;
@property (nonatomic, assign)id<YZTitleScrollViewDelegate> viewDelegate;

- (void)createViewWithArray:(NSArray<ProductNameModel *> *)array;
- (void)slidingActionWith:(CGFloat)offset scrollView:(UIScrollView *)scrollView;
@end
