//
//  YZConTitleView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/11.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZConTitleViewDelegate <NSObject>

- (void)titleViewButActionWithIndex:(NSInteger)index;

@end

@interface YZConTitleView : UIView
@property (nonatomic, strong) UIView *chooseView;
- (void)chooseViewScrollWithIndex:(NSInteger)i;
@property (nonatomic, assign) id <YZConTitleViewDelegate> delegate;
@end
