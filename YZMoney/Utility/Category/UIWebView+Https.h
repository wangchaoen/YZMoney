//
//  UIWebView+Https.h
//  YZMoney
//
//  Created by weekope on 2016/12/7.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIWebView (Https) <NSURLSessionDelegate>

- (void)loadHttpsRequest:(NSURLRequest *)request;

@end
