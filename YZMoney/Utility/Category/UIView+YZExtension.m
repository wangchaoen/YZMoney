//
//  UIView+YZExtension.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/8.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "UIView+YZExtension.h"

@implementation UIView (YZExtension)
- (CGFloat)yz_height
{
    return self.frame.size.height;
}

- (void)setYz_height:(CGFloat)yz_height
{
    CGRect temp = self.frame;
    temp.size.height = yz_height;
    self.frame = temp;
}

- (CGFloat)yz_width
{
    return self.frame.size.width;
}

- (void)setyz_width:(CGFloat)yz_width
{
    CGRect temp = self.frame;
    temp.size.width = yz_width;
    self.frame = temp;
}


- (CGFloat)yz_y
{
    return self.frame.origin.y;
}

- (void)setYz_y:(CGFloat)yz_y
{
    CGRect temp = self.frame;
    temp.origin.y = yz_y;
    self.frame = temp;
}

- (CGFloat)yz_x
{
    return self.frame.origin.x;
}
 - (void)setYz_x:(CGFloat)yz_x
{
    CGRect temp = self.frame;
    temp.origin.x = yz_x;
    self.frame = temp;
}

@end
