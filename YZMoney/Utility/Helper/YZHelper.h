//
//  YZHelper.h
//  YZMoney
//
//  Created by 7仔 on 15/11/11.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface YZHelper : NSObject

+ (NSString *)dateStringFromTimestamp:(NSTimeInterval)time;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)roundCornerImageWithSize:(CGSize)size colorFill:(UIColor *)color;
+ (NSAttributedString *)attributedStringFromText:(NSString *)text font:(float)font;

@end
