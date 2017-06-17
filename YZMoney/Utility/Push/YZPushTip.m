//
//  YZPushTip.m
//  YZMoney
//
//  Created by 7仔 on 16/3/21.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "YZPushTip.h"





@implementation YZPushTip

+ (void)pushTipAdd {
    
}

+ (void)pushTipRemove {
    
}

- (void)drawPushTip {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(0.0f, 0.0f) radius:10.0f startAngle:0.0f endAngle:M_PI*2 clockwise:YES];
    [YZ_RED_COLOR setFill];
    [path fill];
}

@end
