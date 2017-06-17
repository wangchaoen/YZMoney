//
//  YZNavigationControllert.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/17.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZNavigationController.h"
#import "UIImage+ImageWithColor.h"


@implementation YZNavigationController  
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:18], NSFontAttributeName,nil]];
        self.navigationBar.translucent = NO;
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.barTintColor = YZ_RED_COLOR;
        self.navigationBar.barStyle = UIBarStyleBlack;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        UIImage *backImg = [UIImage imageWithColor:YZ_RED_COLOR];
        [self.navigationBar setBackgroundImage:backImg
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    return self;
}

@end
