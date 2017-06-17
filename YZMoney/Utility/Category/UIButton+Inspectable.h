//
//  UIButton+IBInspectable.h
//  YZMoney
//
//  Created by 7仔 on 15/12/30.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIButton (Inspectable)

@property (nonatomic, strong) IBInspectable UIColor *bgColorNormal;
@property (nonatomic, strong) IBInspectable UIColor *bgColorHighlighted;
@property (nonatomic, strong) IBInspectable UIColor *bgColorDisabled;

@end
