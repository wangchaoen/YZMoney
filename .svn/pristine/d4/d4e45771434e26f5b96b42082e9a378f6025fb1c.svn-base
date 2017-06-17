//
//  YZSurveyVC.m
//  YZMoney
//
//  Created by weekope on 16/7/14.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "YZSurveyVC.h"
#import "UIWebView+Https.h"





@interface YZSurveyVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end





@implementation YZSurveyVC

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 20.0f,
                                                               CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20.0f)];
        [_webView loadHttpsRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:_webView];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _webView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _webView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webview

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString containsString:@"yz_app_page_close"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserShouldGet object:nil];
        }];
        return NO;
    }
    else {
        return YES;
    }
}

@end
