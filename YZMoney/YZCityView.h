//
//  YZCityView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/28.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZCityView;

@protocol YZCityViewDelegate <NSObject>

- (void)chooseCityNameWith:(NSString *)address view:(YZCityView *)view;

@end

@interface YZCityView : UIView
@property (nonatomic, assign) id<YZCityViewDelegate> delegate;
@end
