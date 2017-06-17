//
//  YZViewManager.m
//  YZMoney
//
//  Created by 7仔 on 16/1/6.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "YZViewManager.h"



@implementation YZViewManager


+ (void)viewManagerWithTextAndView:(UIView *)view data:(id)data error:(NSError *)error withText:(NSString *)text block:(void (^)())block {
    [self viewManagerBaseWithView:view data:data error:error text:text block:block];
}

+ (void)viewManagerWithView:(UIView *)view
                       data:(id)data
                      error:(NSError *)error
                      block:(void (^)())block {
    [self viewManagerBaseWithView:view data:data error:error text:nil block:block];
}

+ (void)viewManagerBaseWithView:(UIView *)view data:(id)data error:(NSError *)error text:(NSString * _Nullable)text block:(void (^)())block {
    for (UIView *v in view.subviews) {
        if (v.tag==101 || v.tag==102) {
            [v removeFromSuperview];
        }
    }
    
    block();
    if ([data count]) {
        return;
    }
    if (error) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nonetwork.png"]];
        iv.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds)-60.0f);
        iv.tag = 101;
        [view addSubview:iv];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(iv.frame)+10.0f, CGRectGetWidth(view.bounds), 20.0f)];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = @"网络错误";
        l.textColor = RGBColor(159.0f, 159.0f, 159.0f, 1.0f);
        l.tag = 102;
        [view addSubview:l];
        
        return;
    }
    if ([data count]==0) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata.png"]];
        iv.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds)-60.0f);
        iv.tag = 101;
        [view addSubview:iv];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(iv.frame)+10.0f, CGRectGetWidth(view.bounds), 20.0f)];
        l.textAlignment = NSTextAlignmentCenter;
        if (text) {
            l.text = text;
        }else {
            l.text = @"暂无数据";
        }
        l.textColor = RGBColor(159.0f, 159.0f, 159.0f, 1.0f);
        l.tag = 102;
        [view addSubview:l];
        
        return;
    }
}


@end
