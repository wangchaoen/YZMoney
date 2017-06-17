//
//  UIButton+IBInspectable.m
//  YZMoney
//
//  Created by 7仔 on 15/12/30.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "UIButton+Inspectable.h"





@implementation UIButton (Inspectable)

- (UIColor *)bgColorNormal {
    return self.bgColorNormal;
}

- (void)setBgColorNormal:(UIColor *)bgColorNormal {
    [self setBackgroundImage:[YZHelper createImageWithColor:bgColorNormal] forState:UIControlStateNormal];
}

- (UIColor *)bgColorHighlighted {
    return self.bgColorHighlighted;
}

- (void)setBgColorHighlighted:(UIColor *)bgColorHighlighted {
    [self setBackgroundImage:[YZHelper createImageWithColor:bgColorHighlighted] forState:UIControlStateHighlighted];
}

- (UIColor *)bgColorDisabled {
    return self.bgColorDisabled;
}

- (void)setBgColorDisabled:(UIColor *)bgColorDisabled {
    [self setBackgroundImage:[YZHelper createImageWithColor:bgColorDisabled] forState:UIControlStateDisabled];
}

@end
