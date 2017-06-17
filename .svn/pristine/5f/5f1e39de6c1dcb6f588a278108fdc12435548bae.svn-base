//
//  YZWebViewVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/5/4.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZWebViewVC.h"
#import "UIWebView+Https.h"


@interface YZWebViewVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *viewProgress;
@end

@implementation YZWebViewVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserHasGet object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserHasRemove object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H)];
    [self.view addSubview:self.webView];
    [self webViewRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHasGet)
                                                 name:kUserHasGet
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHasRemove)
                                                 name:kUserHasRemove
                                               object:nil];
    _viewProgress = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, CGRectGetWidth(self.view.frame)/5, 4.0f)];
    _viewProgress.backgroundColor = YZ_RED_COLOR;
    [self.view addSubview:_viewProgress];

}
- (void)userHasGet {
    [self webViewRequest];
}
- (void)userHasRemove {
    [self webViewRequest];
}
- (void)webViewRequest {
    NSString *url = [NSString stringWithFormat:@"%@product/v2/detail?productId=%@", url_base, @"1"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    [request setValue:[NSString stringWithFormat:@"%@", [DataManager sharedManager].userAgent] forHTTPHeaderField:@"User-Agent"];
    [request setValue:[NSString stringWithFormat:@"%@", [DataManager sharedManager].userAgent] forHTTPHeaderField:@"UserAgent"];
    NSLog(@"%@\n%@", [DataManager sharedManager].userAgent, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"yz-version"];
    if ([DataManager sharedManager].deviceToken) {
        [request setValue:[DataManager sharedManager].deviceToken forHTTPHeaderField:@"umengDeviceToken"];
    }
    
    [_webView loadHttpsRequest:request];
}
#pragma mark - Utils
- (void)progressViewFinish {
    WEAK_SELF;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.viewProgress.frame = CGRectMake(0.0f, 64.0f, CGRectGetWidth(weakSelf.view.frame), 4.0f);
                     }
                     completion:^(BOOL finished) {
                         [weakSelf.viewProgress removeFromSuperview];
                     }];
}

#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self progressViewFinish];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self progressViewFinish];
}

@end
