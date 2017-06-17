//
//  YZProductDetailVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/9.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZProductDetailVC.h"
#import "YZProductAppointVC.h"
#import "YZActionSheet.h"
#import "YZProductModel.h"
#import "YZMineServiceVC.h"
#import "YZEmailView.h"
#import "YZProductDocumentVC.h"
#import "UIWebView+Https.h"
#import <MSWeakTimer/MSWeakTimer.h>
#import "WebViewController.h"
#import "UIImage+ImageWithColor.h"
#import "InstitutionController.h"
#import "YZLabelVC.h"

@interface YZProductDetailVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (nonatomic, strong) UIWebView *webView;

@property (strong, nonatomic) UIButton *btnAppoint;
@property (nonatomic, strong) YZProductModel *product;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) NSString *idFavorite;
@property (nonatomic, strong) UIView *viewProgress;

#pragma mark - H5交互
@property (nonatomic, copy) NSArray *docList;
@property (nonatomic, copy) NSArray *listCopy;
@property (nonatomic, copy) NSArray *tagList;
@end





@implementation YZProductDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (self.isProjectVC) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    if (self.column.length <= 0) {
        self.column = @"";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self apiRequest];
    self.webView.frame = CGRectMake(0, 64, S_W, S_H);

    [MobClick event:@"detail_view"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHasGet:)
                                                 name:kUserHasGet
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userHasRemove:)
                                                 name:kUserHasRemove
                                               object:nil];
    
    
    _viewProgress = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, CGRectGetWidth(self.view.frame)/5, 4.0f)];
    _viewProgress.backgroundColor = YZ_RED_COLOR;
    [self.view addSubview:_viewProgress];

    for (int i = 0; i < (self.isProjectVC ? 0 : 4); i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(i % 4 * (S_W / 4), S_H - 49, S_W / 4, 49);
        but.backgroundColor = [UIColor whiteColor];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        [but setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        [self.view addSubview:but];
        
        if (i == 0) {
            [but setTitle:@"客服" forState:UIControlStateNormal];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(but.frame) - 1, S_H - 49 + 4, 1, 49 - 8)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:line];
            [but addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 2) {
            [but setTitle:@"收藏" forState:UIControlStateNormal];
            but.tag = 1;
            [but addTarget:self action:@selector(actionFavorite:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 1) {
            [but setTitle:@"邮件" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(actionEmail) forControlEvents:UIControlEventTouchUpInside];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(but.frame) - 1, S_H - 49 + 4, 1, 49 - 8)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:line];
        }else{
            [but setBgColorNormal:YZ_RED_COLOR];
            [but setBgColorDisabled:[UIColor lightGrayColor]];
            [but setTitle:@"预约" forState:UIControlStateNormal];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(btnAppointAction) forControlEvents:UIControlEventTouchUpInside];
            self.btnAppoint = but;
        }
    }
}

- (void)apiRequest {
    if (_url) {
        NSArray *arr = [[NSURL URLWithString:_url].query componentsSeparatedByString:@"&"];
        for (NSString *str in arr) {
            if ([str containsString:@"productId"]) {
                _idProduct = [str substringFromIndex:10];
            }
        }
    }
    
    NSString *url;
    if (self.isProjectVC) {
        url = _url;
    }else{
        url = [NSString stringWithFormat:@"%@product/detail?productId=%@&columnUrl=%@", url_base, _idProduct, self.column];
    }
    
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadHttpsRequest:request];
    if (self.isProjectVC) {
        return;
    }
    WEAK_SELF;
    [YZHttpApiManager apiProductWithParameters:@{@"productId": _idProduct, @"columnUrl": self.column}
                             completionHandler:^(id response, NSError *error) {
                                 weakSelf.product =     [[YZProductModel alloc] initWithDict:response[@"data"]];
                                 if (!weakSelf.isProjectVC) {
                                     [weakSelf createTitle];
                                 }
                                 weakSelf.listCopy = [response valueForKeyPath:@"data.copyList"];
                                 weakSelf.tagList = [response valueForKeyPath:@"data.tagList"];
                                 weakSelf.docList = [response valueForKeyPath:@"data.docList"];
                                 
                                 if (weakSelf.product.offsetTime > 0) {
                                     weakSelf.btnAppoint.enabled = NO;
                                     
                                     [MSWeakTimer scheduledTimerWithTimeInterval:5
                                                                          target:self
                                                                        selector:@selector(countDown:)
                                                                        userInfo:nil
                                                                         repeats:YES
                                                                   dispatchQueue:dispatch_get_main_queue()];
                                 }else {
                                     weakSelf.btnAppoint.enabled = YES;
                                     [weakSelf.btnAppoint setTitle:@"预约" forState:UIControlStateNormal];
                                     if (weakSelf.product.soldOut) {
                                         weakSelf.btnAppoint.enabled = NO;
                                         [weakSelf.btnAppoint setTitle:@"售罄" forState:UIControlStateDisabled];
                                     }
                                     if (!weakSelf.product.onMarketing) {
                                         weakSelf.btnAppoint.enabled = NO;
                                         [weakSelf.btnAppoint setTitle:@"失效" forState:UIControlStateDisabled];                          }
                                 }
                                 
                                 if (self.docId) {                                 for (NSDictionary *dic in weakSelf.docList) {
                                     if ([dic[@"id"] isEqualToString:self.docId]) {
                                         NSString *url = dic[@"path"];
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self openPDFwithUrl:url title:dic[@"fullName"]];                                        });                                         break;                                      }
                                 }
                                 }
                             }];
    
    if (ISLOGIN) {
        [self likeRequest];
    }
}

- (void)likeRequest {
    WEAK_SELF;
    [YZHttpApiManager apiProductIsFavoriteWithParameters:@{@"ids": _idProduct}
                                       completionHandler:^(id response, NSError *error) {
                                           weakSelf.idFavorite = [[[response valueForKeyPath:@"data"] firstObject] valueForKey:@"favoriteId"];
                                           if (weakSelf.idFavorite.length) {
                                               [(UIButton *)[weakSelf.view viewWithTag:1] setTitle:@"取消收藏" forState:UIControlStateNormal];
                                           }
                                           else {
                                               [(UIButton *)[weakSelf.view viewWithTag:1] setTitle:@"收藏" forState:UIControlStateNormal];
                                           }
                                       }];
}

- (void)countDown:(MSWeakTimer *)timer {
    if (_countDown < _product.offsetTime-1) {
        _countDown++;
        NSInteger offset = _product.offsetTime-_countDown;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:offset] options:0];
        NSString *h = components.hour<10?[NSString stringWithFormat:@"0%ld",(long)components.hour]:[NSString stringWithFormat:@"%ld",(long)components.hour];
        NSString *m = components.minute<10?[NSString stringWithFormat:@"0%ld",(long)components.minute]:[NSString stringWithFormat:@"%ld",(long)components.minute];
        NSString *s = components.second<10?[NSString stringWithFormat:@"0%ld",(long)components.second]:[NSString stringWithFormat:@"%ld",(long)components.second];
        [_btnAppoint setTitle:[NSString stringWithFormat:@"%@:%@:%@",h,m,s] forState:UIControlStateDisabled];
    }else {
        [timer invalidate];
        _btnAppoint.enabled = YES;
        [_btnAppoint setTitle:@"我要预约" forState:UIControlStateNormal];
    }
}

- (void)createTitle {
    WEAK_SELF;
    UIScrollView *scorll = [[UIScrollView alloc]initWithFrame:CGRectMake(33, 5, S_W, 40)];
    CGSize size = [Utility calculatelblSizeForFont:18 scope:CGSizeMake(100000, 30) text:weakSelf.product.title];
    UILabel *lbl = [[UILabel alloc]init];
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.textColor = [UIColor whiteColor];
    CGFloat w = size.width > (S_W - 121) ? size.width : (S_W - 121);
    lbl.frame = CGRectMake(0, 0, w, 40);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = weakSelf.product.title;
    [scorll addSubview:lbl];
    [scorll setContentSize:CGSizeMake(lbl.frame.size.width, 0)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.navigationItem.titleView = scorll;
    });
    
}
#pragma mark - notification

- (void)userHasGet:(NSNotification *)noti {
    [self apiRequest];
}

- (void)userHasRemove:(NSNotification *)noti {
    [self apiRequest];
}

#pragma mark - webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.absoluteString;
    url = [url stringByReplacingOccurrencesOfString:@";" withString:@""];
    if ([url containsString:@"passport/login"]) {
        // 登录
        [Utility goLogin];
        return NO;
    }else if ([url containsString:@"app_server_copy"]){
        //复制
        NSArray *array = [url componentsSeparatedByString:@"app_server_copy:"];
        NSInteger i = [[array lastObject] integerValue];
        NSString *str = _listCopy[i];
        [self copyActionWithText:str];
        return NO;
        
    }else if ([url containsString:@"app_server_detail"]){
        //产品详情
        NSArray *array = [url componentsSeparatedByString:@"app_server_detail:"];
        NSString *str = [array lastObject];
        NSArray *parameter = [str componentsSeparatedByString:@","];
        NSString *ID = [parameter firstObject];
        NSString *checkLogin = [parameter lastObject];
        if ([checkLogin boolValue] && !ISLOGIN) {
            [Utility goLogin];
        }else {
            [self prodectTypeDetailVCWith:ID column:@""];
        }
        return NO;
        
    }else if ([url containsString:@"app_server_file"]){
        //PDF
        NSArray *array = [url componentsSeparatedByString:@"app_server_file:"];
        NSInteger i = [[array lastObject] integerValue];
        NSDictionary *dic = _docList[i];
        if (!dic) {
            return NO;
        }
        NSString *url = dic[@"path"];
        if (_product.docCheckLogin && !ISLOGIN) {
            [Utility goLogin];
        }else {
            [self openPDFwithUrl:url title:dic[@"fullName"]];
        }
        return NO;
    }else if ([url containsString:@"app_server_company"]) {
        //产品机构
        NSArray *array = [url componentsSeparatedByString:@"app_server_company:"];
        NSString *parmasStr = [array lastObject];
        NSArray *parmas = [parmasStr componentsSeparatedByString:@","];
        NSString *ID = parmas.firstObject;
        //        NSString *column = parmas.lastObject;
        [self prodectActionWithID:ID column:self.column];
        return NO;
    }else if ([url containsString:@"app_server_tag"]){
        NSArray *array = [url componentsSeparatedByString:@"app_server_tag:"];
        NSInteger i = [[array lastObject] integerValue];
        if (self.tagList.count > i) {
            NSString *str = self.tagList[i];
            [self prodectLabelWith:str];
        }
        return NO;
    }
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    WEAK_SELF;
    [YZViewManager viewManagerWithView:_webView
                                  data:nil
                                 error:error
                                 block:^(){
                                     [weakSelf progressViewFinish];                                   }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webView.frame = CGRectMake(0, 64, S_W, S_H  - (self.isProjectVC ? 64 : (49 + 64)));
    [self progressViewFinish];
    if (self.isProjectVC) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    NSLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
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
#pragma mark - JS action
// copyUtils
- (void)copyActionWithText:( NSString *)text {
    if (text) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [YZToastView showToastWithText:@"复制成功"];
    }else {
        [YZToastView showToastWithText:@"复制失败"];
    }
}
// PDF
- (void)openPDFwithUrl:(NSString *_Nullable)url title:(NSString *)title{
    WebViewController *webVC = [[WebViewController alloc]initWithUrl:url title:title];
    [self.navigationController pushViewController:webVC animated:YES];
}
// label
- (void)prodectTypeDetailVCWith:(NSString *)ID column:(NSString *)column{
    YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
    productVC.idProduct = ID;
    productVC.column = column;
    [self.navigationController pushViewController:productVC animated:YES];
}
- (void)prodectActionWithID:(NSString *)ID column:(NSString *)column{
    InstitutionController *vc = [[InstitutionController alloc]initWithTitle: _product.issuer companyId:ID columnUrl:column];
    [self.navigationController pushViewController:vc animated:YES];
}
// label
- (void)prodectLabelWith:(NSString *)str {
    YZLabelVC *vc = [[YZLabelVC alloc]initWithTitle:str];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action
- (IBAction)actionMore:(UIBarButtonItem *)sender {
    if (ISLOGIN) {
        YZActionSheet *as = [[YZActionSheet alloc] initWithID:nil
                                                      arrMore:nil
                                                     arrShare:@[@"微信好友", @"朋友圈"]];
        if (self.isProjectVC) {
            as.shareUrl = self.model.shareUrl;
            as.shareTitle = self.model.name;
            as.shareContent = self.model.desc;
        }else{
            as.shareUrl = _product.shareUrl;
            as.shareTitle = _product.title;
            as.shareContent = _product.title;
        }
        as.shareImage = [UIImage imageNamed:@"80.png"];

        [as show];
    }else {
        [Utility goLogin];
    }
}

- (void)actionFavorite:(UIButton *)sender {
    if (!ISLOGIN) {
        [Utility goLogin];
        return;
    }
    if (!_idFavorite.length) {
        WEAK_SELF;
        [YZHttpClient requestWithNoToastMethod:@"POST" url:@"member/favorite/add" parameters:@{@"pid": _idProduct} completionHandler:^(id response, NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOT_REFESH_FAVORITEVC object:nil];
            weakSelf.idFavorite = [response valueForKeyPath:@"data.favoriteData.id"];
            [MobClick event:@"detail_favor" label:@"收藏"];
            [(UIButton *)[self.view viewWithTag:1] setTitle:@"取消收藏" forState:UIControlStateNormal];   [YZToastView showToastWithText:@"收藏成功"];
        } finished:^{
            
        }];
        
    }else {
        WEAK_SELF;
        [YZHttpApiManager apiProductFavoriteWithParameters:@{@"id": self.idFavorite}
                                         completionHandler:^(id response, NSError *error) {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:NOT_REFESH_FAVORITEVC object:nil];
                                             //                                             [self apiRequest];
                                             weakSelf.idFavorite = @"";
                                             
                                             [(UIButton *)[self.view viewWithTag:1] setTitle:@"收藏" forState:UIControlStateNormal];  [YZToastView showToastWithText:@"取消收藏成功"];
                                            
                                         }];
    }
    
    [MobClick event:@"loveDetail" label:@"收藏"];
}
- (void)callAction {
    YZMineServiceVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_service"];
    vc.idProduct = _idProduct;
    [self.navigationController pushViewController:vc animated:YES];
    [MobClick event:@"callDetail" label:@"咨询"];
    
}
- (void)btnAppointAction {
    if (!ISLOGIN) {
        [Utility goLogin];
        return;
    }
    [YZHttpClient requestWithNoToastMethod:@"POST" url:@"member/order/preBooking" parameters:@{@"productId": self.idProduct} completionHandler:^(id response, NSError *error) {
        YZProductAppointVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product_appoint"];
        vc.idProduct = _idProduct;
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"detail_order" label:@"预约"];
    } finished:^{
        
    }];
}

- (void)actionEmail {
    if (ISLOGIN) {
        [MobClick event:@"detail_mail"];
        YZEmailView *ev = [[[NSBundle mainBundle] loadNibNamed:@"YZEmailView" owner:nil options:nil] firstObject];
        ev.frame = [[UIScreen mainScreen] bounds];
        ev.idProduct = _idProduct;
        [APPDELEGATE.window addSubview:ev];
        ev.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            ev.alpha = 1;
        }];
    }
    else {
        [Utility goLogin];
    }
    
    [MobClick event:@"mailDetail" label:@"邮件"];
}

#pragma mark - segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (([identifier isEqualToString:@"segue_product_appoint"] && !yz_user) || ([identifier isEqualToString:@"segue_product_doc"] && !yz_user)) {
        [Utility goLogin];
        return NO;
    }
    else {
        return YES;
    }
}
@end