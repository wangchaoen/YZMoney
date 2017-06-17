//
//  WebViewController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/7.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "WebViewController.h"
#import "UIWebView+Https.h"
#import "YZToastView.h"
#import <WebKit/WebKit.h>
#import "YZActionSheet.h"
#import "WKWebView+Https.h"

@interface WebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *titleStr;

@end

@implementation WebViewController
- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title{
    self = [super init];
    if (self) {
        self.url = url;
        self.title = title;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _webView.navigationDelegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _webView.navigationDelegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_image"] style:UIBarButtonItemStylePlain target:self action:@selector(rightShareButAction)];
    self.navigationItem.rightBarButtonItem = rightBut;
    
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_H)];
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
//    [_webView loadHttpsRequest:request];
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[YZToastView sharedToast] showToast];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [[YZToastView sharedToast] hideToast];
}
// 页面加载失败时调用
- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
    [YZToastView showToastWithText: @"页面加载错误！"];
    [[YZToastView sharedToast] hideToast];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)rightShareButAction {
    if (ISLOGIN) {
        YZActionSheet *as = [[YZActionSheet alloc] initWithID:nil
                                                      arrMore:nil
                                                     arrShare:@[@"微信好友"]];
        as.shareUrl = self.url;
        as.shareTitle = self.title;
        as.shareContent = self.title;
        as.shareImage = [UIImage imageNamed:@"80.png"];
        [as show];
    }
    else {
        [Utility goLogin];
    }
}

@end
