//
//  WKWebView+WKWebView_https.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/27.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Https)<NSURLSessionDelegate>
- (void)loadHttpsRequest:(NSURLRequest *)request;
@end
