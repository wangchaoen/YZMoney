//
//  UIImage+ImageWithColor.h
//  MA Mobile
//
//  Created by Brandon Butler on 6/28/12.
//  Copyright (c) 2012 POS Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageWithTintColor:(UIColor *)color;

@end
