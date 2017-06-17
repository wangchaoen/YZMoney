//
//  AppDelegate.m
//  YZMoney
//
//  Created by 7仔 on 15/11/4.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "YZMineVC.h"
#import "YZIndexVC.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "YZProductDetailVC.h"
#import "YZNewsDetailVC.h"
#import "UIViewController+Swizzled.h"
#import "YZMineAppointDetailVC.h"
#import "YZAppointModel.h"
#import "UIViewController+Utils.h"
#import "IQKeyboardManager.h"
#import "WebViewController.h"
#import "OpenUDID.h"
#import "PDKeyChain.h"
#import "YZProgressVC.h"
#import "YZAdvertisingView.h"


@interface AppDelegate () <UITabBarControllerDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, assign, getter=isReceivedPush) BOOL receivedPush;
@property (nonatomic, copy) NSDictionary *dic;
@end





@implementation AppDelegate

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailto:test@qq.com"];
    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", content];
    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}

- (void)updateUserAgent{
    //    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"User-Agent"]);
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    //        NSLog(@"------%@",userAgent);
    //    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    // build       NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    //version
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    NSString *ua = [NSString stringWithFormat:@"%@ %@/;yz_version:%@",
    //                    userAgent,
    //                    executableFile,version];
    //    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
    [DataManager sharedManager].userAgent = userAgent;
    //#if !__has_feature(objc_arc)
    //    [tempWebView release];
    //#endif
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (![PDKeyChain keyChainLoad]) {
        [DataManager sharedManager].openUDID = [OpenUDID value];
        [PDKeyChain keyChainSave: [DataManager sharedManager].openUDID];
    }else {
        [DataManager sharedManager].openUDID = [PDKeyChain keyChainLoad];
    }
    
    [DataManager sharedManager].sessionid = [NSString stringWithFormat:@"%@%@", [Utility currentTime], [[Utility shuffledAlphabet] substringToIndex:6]];
    
    SWIZZ_IT;
    [self updateUserAgent];
    //    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userShouldGet:)
                                                 name:kUserShouldGet
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userShouldRemove:)
                                                 name:kUserShouldRemove
                                               object:nil];
    
    [DataManager sharedManager].w = fmin(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    [DataManager sharedManager].h = fmax(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    
    [self umengConfigurationWithOptions:launchOptions];
    
#ifdef DEBUG
#else
    //     GrowingIO
    [Growing startWithAccountId:GrowingIOKey];
    //     其他配置
    //     开启Growing调试日志 可以开启日志
    [Growing setEnableLog:YES];
#endif
    
    //    [YZHttpClient requestWithNoToastMethod:@"POST" url:@"edition/isPublish" parameters:nil completionHandler:^(id response, NSError *error) {
    //            "success": true,
    //            "data": 1[1 提交AppStore ，0 发布],
    //            "msg": null,
    //            "msgCode": null
    //    } finished:^{
    //
    //    }];
    
    //    [YZHttpApiManager apiConfigureWithParameters:@{@"versionStr": [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"],
    //                                                   @"osType"    : @(2),
    //                                                   @"osStr"     : [[UIDevice currentDevice] systemVersion]}
    //                               completionHandler:^(id response, NSError *error) {
    //
    //                               }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [ShowStartView integerValue] == 1 ? [infoDictionary objectForKey:@"CFBundleShortVersionString"]: @"0";
    NSString *lastVersion = [ShowStartView integerValue] == 1 ?  [[NSUserDefaults standardUserDefaults] valueForKey:KVresion] : @"0";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserFirstEnter] && [lastVersion isEqualToString:nowVersion]) {
        _window.rootViewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"launchScreen"];
        [YZHttpApiManager apiBootadWithParameters:nil
                                completionHandler:^(id response, NSError *error) {
                                    [self enterAPPWithAD:nil];
                                    if ([[response valueForKeyPath:@"data.adData"] count]) {
                                        NSInteger i = arc4random()%[[response valueForKeyPath:@"data.adData"] count];
                                        NSString *url = [[[response valueForKeyPath:@"data.adData"] objectAtIndex:i] valueForKey:@"image"];
                                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAD:)];
                                        tap.accessibilityHint = [[[response valueForKeyPath:@"data.adData"] objectAtIndex:i] valueForKey:@"url"];
                                        YZAdvertisingView *view =[[YZAdvertisingView alloc]initWithFrame:self.window.bounds];
                                        [self.window addSubview:view];
                                        [view addGestureRecognizer:tap];
                                        [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"start_image"]];
                                    }
                                }];
    }
    [[UITabBar appearance] setTintColor:RGBColor(235.0f, 18.0f, 18.0f, 1.0f)];
    //    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
    //        [self handleWithPush:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    //    }
    
    return YES;
}
#pragma mark - 打开APP回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [self openUrlWith:app url:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self openUrlWith:application url:url];
}
- (BOOL)openUrlWith:(UIApplication *)app url:(NSURL *)url {
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"yzmoney"]) {
        if (app.applicationState == UIApplicationStateInactive) {
            UIViewController *vc = [UIViewController currentViewController];
            [vc.navigationController popToRootViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [Utility tabBarWithIndex:0];
            });
        }
        if ([urlStr containsString:@"actionType=home"]) {
            
        }else if ([urlStr containsString:@"actionType=product"]) {
            NSString *ID = [[[url.absoluteString componentsSeparatedByString:@"&"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"id=" withString:@""];
            NSString *docId;
            if ([url.absoluteString containsString:@"docId="]) {
                docId = [[url.absoluteString componentsSeparatedByString:@"&docId="] lastObject];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (ISLOGIN) {
                    [self productUtilsWithUrl:ID docId:docId column:@"app_home"];
                }
            });
            return YES;
        }else if ([urlStr containsString:@"actionType=article"]){
            NSString *ID = [[[url.absoluteString componentsSeparatedByString:@"&"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"id=" withString:@""];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (ISLOGIN) {
                    YZNewsDetailVC *newsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_news"];
                    newsVC.idNews = ID;
                    newsVC.hidesBottomBarWhenPushed = YES;
                    UIViewController *vc = [UIViewController currentViewController];
                    [vc.navigationController pushViewController:newsVC animated:YES];
                }
            });
            return YES;
        }else if ([urlStr containsString:@"actionType=file"]){
            NSString *urlFile = [[url.absoluteString componentsSeparatedByString:@"&url="] lastObject];
            NSString *ID = [[[url.absoluteString componentsSeparatedByString:@"&"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"id=" withString:@""];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (ISLOGIN) {
                    [self PDFWithUrl:urlFile title:@"资料"ID:ID];
                }
            });
            return YES;
        }
        return YES;
    }else if ([url.absoluteString containsString:WChatKey] || [url.absoluteString containsString:WChatKey2]) {
        [WXApi handleOpenURL:url delegate:(YZMineVC *)[(UINavigationController *)[(UITabBarController *)_window.rootViewController selectedViewController] topViewController]];
        return YES;
    }else if ([url.absoluteString containsString:@"growing.0b364bac6dca4835"]){
        return [Growing handleUrl:url];
    }
    return YES;
    
}

#pragma mark - 推送
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
    NSLog(@"注册远程通知失败");
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    [DataManager sharedManager].deviceToken =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"%@", [DataManager sharedManager].deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState != UIApplicationStateActive) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![[NSUserDefaults standardUserDefaults] valueForKey:kUserOnline]) {
                [Utility goLogin];
                weakSelf.receivedPush = YES;
                weakSelf.dic = userInfo;
                return;
            }
            [weakSelf handleWithPush:userInfo];
        });
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState != UIApplicationStateActive) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![[NSUserDefaults standardUserDefaults] valueForKey:kUserOnline]) {
                [Utility goLogin];
                weakSelf.receivedPush = YES;
                weakSelf.dic = userInfo;
                return;
            }
            [weakSelf handleWithPush:userInfo];
        });
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    [self handleWithPush:response.notification.request.content.userInfo];
}

#pragma mark - 暂时没用到
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - user
- (void)userShouldGet:(NSNotification *)noti {
    [YZHttpApiManager apiUserWithParameters:nil
                          completionHandler:^(id response, NSError *error) {
                              if (response) {
                                  [MobClick event:@"usercenter_login"];
                                  yz_user = [[YZUserModel alloc] initWithDict:[response valueForKeyPath:@"data.memberData"]];
                                  [YZCacheHelper cacheObject:yz_user file:@"user"];
                              }
                              else {
                                  yz_user = [YZCacheHelper objectCachedWithFile:@"user"];
                              }
                              yz_user.iconImage = [YZCacheHelper getDocumentImage];
                              [[NSUserDefaults standardUserDefaults] setValue:kUserOnline forKey:kUserOnline];
                              [[NSNotificationCenter defaultCenter] postNotificationName:kUserHasGet object:nil];
                              if (self.isReceivedPush) {
                                  [self handleWithPush:self.dic];
                              }
                          } finished:^{
                              
                          }];
}

- (void)userShouldRemove:(NSNotification *)noti {
    yz_user = nil;
    [YZCacheHelper cacheObject:yz_user file:@"user"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserOnline];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLoginCookie];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserHasRemove object:nil];
}

#pragma mark - UMeng注册
- (void)umengConfigurationWithOptions:(NSDictionary *)options {
    [UMSocialData setAppKey: UMengKey];
    [YZHttpApiManager apiWChatIDWithParameters:nil completionHandler:^(id response, NSError *error) {
        if (response) {
            NSString *data = response[@"data"];
            BOOL judge = [data isEqualToString:WChatKey];
            [DataManager sharedManager].isWChat2 = judge ? NO : YES;
            [UMSocialWechatHandler setWXAppId: judge ? WChatKey : WChatKey2
                                    appSecret: judge ? WChatAppSecret :WChatAppSecret2
                                          url:nil];
        }else {
            [DataManager sharedManager].isWChat2 = YES;
            [UMSocialWechatHandler setWXAppId: WChatKey2
                                    appSecret:WChatAppSecret2
                                          url:nil];
            
        }
    } finished:^{
        
    }];
    
    UMConfigInstance.appKey = UMengKey;
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [MobClick startWithConfigure:UMConfigInstance];
    [UMessage startWithAppkey: UMengKey
                launchOptions:options
                  httpsenable:YES];
    [UMessage registerForRemoteNotifications];
    
    //ios 10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  //这里可以添加一些自己的逻辑
                              } else {
                                  //点击不允许
                                  //这里可以添加一些自己的逻辑
                              }
                          }];
}

- (void)handleWithPush:(NSDictionary *)push {
    self.receivedPush = NO;
    if ([push[@"afterOpenAction"] integerValue] == 2) {
        YZNewsDetailVC *newsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_news"];
        newsVC.url = push[@"data"];
        newsVC.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)[(UITabBarController *)_window.rootViewController selectedViewController] pushViewController:newsVC animated:YES];
    }
    else if ([push[@"afterOpenAction"] integerValue] == 4) {
        if ([push[@"dataType"] integerValue] == 1) {
            YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
            productVC.hidesBottomBarWhenPushed = YES;
            productVC.idProduct = push[@"data"];
            if (push[@"column"]) {
                productVC.column = push[@"column"];
            }
            [(UINavigationController *)[(UITabBarController *)_window.rootViewController selectedViewController] pushViewController:productVC animated:YES];
            
        }
        else if ([push[@"dataType"] integerValue] == 2) {
            YZNewsDetailVC *newsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_news"];
            newsVC.url = push[@"data"];
            newsVC.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)[(UITabBarController *)_window.rootViewController selectedViewController] pushViewController:newsVC animated:YES];
        } else if ([push[@"dataType"] integerValue] == 3)  {
            //产品详情
            if (!push[@"data"]) {
                return;
            }
            YZMineAppointDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"apppoint_detail_vc"];
            YZAppointModel *model = [[YZAppointModel alloc]init];
            model.ID = push[@"data"];
            [vc setAppoint:model];
            vc.hidesBottomBarWhenPushed = YES;
            UIViewController *pushVC = [UIViewController currentViewController];
            [pushVC.navigationController pushViewController:vc animated:YES];
            
        }
    }else if ([push[@"afterOpenAction"] integerValue] == 4){
        
    }else if([push[@"afterOpenAction"] integerValue] == 5) {
        
        YZProgressVC *vc = [[YZProgressVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.applyCompactId = push[@"data"];
        UIViewController *pushVC = [UIViewController currentViewController];
        [pushVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)enterAPPWithAD:(NSString *)ad {
    _window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbar_controller"];
    [(UITabBarController *)_window.rootViewController setDelegate:self];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserOnline]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserShouldGet object:nil];
    }
    
    if (ad) {
        YZIndexVC *ivc = [(UINavigationController *)((UITabBarController *)_window.rootViewController).selectedViewController viewControllers].firstObject;
        if ([ad containsString:@"linkType=product"]) {
            [ivc performSegueWithIdentifier:@"segue_ad_product" sender:ad];
        }
        else if ([ad containsString:@"linkType=article"]) {
            [ivc performSegueWithIdentifier:@"segue_ad_news" sender:ad];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad]];
        }
    }
}

- (void)tapAD:(UITapGestureRecognizer *)gesture {
    NSString *ad = gesture.accessibilityHint;
    if (ad) {
        YZIndexVC *ivc = [(UINavigationController *)((UITabBarController *)_window.rootViewController).selectedViewController viewControllers].firstObject;
        if ([ad containsString:@"linkType=product"]) {
            [ivc performSegueWithIdentifier:@"segue_ad_product" sender:ad];
        }
        else if ([ad containsString:@"linkType=article"]) {
            [ivc performSegueWithIdentifier:@"segue_ad_news" sender:ad];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad]];
        }
    }
}
#pragma mark - Utils
- (void)productUtilsWithUrl:(NSString *)url docId:(NSString *)docId column:(NSString *)column{
    YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
    productVC.hidesBottomBarWhenPushed = YES;
    productVC.idProduct = url;
    productVC.column = column;
    if (docId && docId.length > 0) {
        productVC.docId = docId;
    }
    UIViewController *vc = [UIViewController currentViewController];
    [vc.navigationController pushViewController:productVC animated:YES];
}
- (void)PDFWithUrl:(NSString *)url title:(NSString *)title ID:(NSString *)ID {
    WebViewController *webVC = [[WebViewController alloc]initWithUrl:url title:title];
    webVC.hidesBottomBarWhenPushed = YES;
    UIViewController *vc = [UIViewController currentViewController];
    [vc.navigationController pushViewController:webVC animated:YES];
    
    //    NSMutableArray *arr = [vc.navigationController.viewControllers mutableCopy];
    //    YZProductDetailVC *product = [[YZProductDetailVC alloc]init];
    //    product.idProduct = ID;
    //    product.hidesBottomBarWhenPushed = YES;
    //    [arr insertObject:product atIndex:arr.count - 1];
    //    vc.navigationController.viewControllers = arr;
}
#pragma mark - tabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSArray *arr = @[@"/home", @"/product", @"/zx", @"/user"];
    [MobClick event:@"dockIndex" label:arr[[tabBarController.viewControllers indexOfObject:viewController]]];
}

@end
