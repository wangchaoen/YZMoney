//
//  UIView+Inspectable.m
//  YZMoney
//
//  Created by 7仔 on 16/1/14.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "UIView+Inspectable.h"





@implementation UIView (Inspectable)

- (UIColor *)colorBorder {
    return self.colorBorder;
}

- (void)setColorBorder:(UIColor *)colorBorder {
    self.layer.borderColor = colorBorder.CGColor;
}

@end
