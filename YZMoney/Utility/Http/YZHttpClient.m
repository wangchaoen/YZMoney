//
//  YZHttpClient.m
//  YZMoney
//
//  Created by 7仔 on 15/11/5.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZHttpClient.h"
#import "AFHTTPSessionManager.h"
#import "YZSurveyVC.h"





@implementation YZHttpClient


#pragma mark - requestOpen
+ (void)requestWithNoToastMethod:(NSString *)method
                      url:(NSString *)url
               parameters:(id)parameters
               completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(void(^)())finished{
    
    [YZHttpClient requestWithShowToast:NO method:method url:url parameters:parameters completionaHander:completionHandler finished:finished];
}

+ (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               parameters:(id)parameters
        completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithShowToast:YES method:method url:url parameters:parameters completionaHander:completionHandler finished:nil];
}

#pragma mark - request
+ (void)requestWithShowToast:(BOOL)judge method:(NSString *)method url:(NSString *)url parameters:(id)parameters completionaHander:(void(^)(id, NSError *))completionHandler finished:(void(^)())finished{
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    if(reachManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (finished) {
            finished();
        }
        [YZToastView showToastWithText:@"当前没有网络"];
        return;
    }

    //添加cookies
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KLoginCookie] && [[NSUserDefaults standardUserDefaults] objectForKey:kUserOnline]) {
        [Utility loadCookies];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    if (judge) {
        [[YZToastView sharedToast] showToast];
    }
    [(AFJSONResponseSerializer *)manager.responseSerializer setRemovesKeysWithNullValues:YES];
    
    //添加请求头
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", [DataManager sharedManager].userAgent] forHTTPHeaderField:@"User-Agent"];
     [manager.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"yz-version"];
    [manager.requestSerializer setValue:[DataManager sharedManager].sessionid forHTTPHeaderField:@"yz-startid"];
    [manager.requestSerializer setValue:[DataManager sharedManager].openUDID forHTTPHeaderField:@"yz-deviceid"];
    if ([DataManager sharedManager].deviceToken) {
        [manager.requestSerializer setValue:[DataManager sharedManager].deviceToken forHTTPHeaderField:@"umengDeviceToken"];
    }
    //判断是否是验证码
    if ([url isEqualToString:@"checkcode"]) {
        manager.responseSerializer = [AFImageResponseSerializer serializer];
    }
    //https
    [manager setSecurityPolicy:[self customSecurityPolicyWithValidate:YES]];
    
    url = [url_base stringByAppendingString:url];
    
    //log param and url
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:parameters ?: @{}];
    [newParams setObject:@"1" forKey:@"root"];
    
    NSLog(@"============================================");
    NSLog(@"= request begin");
    NSLog(@"============================================");
    NSLog(@"heads = %@", [manager.requestSerializer HTTPRequestHeaders]);
    
#ifdef DEBUG
    NSString *fullURLStr;
    {
        NSMutableString *postBody = [NSMutableString string];
        for (NSString *paramKey in newParams) {
            id value = [newParams objectForKey:paramKey];
            if ([value isKindOfClass:[NSString class]]) {
                value = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
            }
            NSUInteger length = [postBody length];
            NSString *paramFormat = (length == 0 ? @"%@=%@" : @"&%@=%@");
            [postBody appendFormat:paramFormat, paramKey, value];
        }
        
        fullURLStr = postBody.length > 0 ? [NSString stringWithFormat:@"%@?%@", url, postBody] : url;
        NSLog(@"url = %@", fullURLStr);
    }
    NSLog(@"params = %@", newParams);
#endif
    
    //request
    if ([method isEqualToString:@"GET"]) {
        // Get Request
        [manager GET:url
          parameters:newParams
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                 if (finished) {
                     finished();
                 }
                 if (judge) {
                     [[YZToastView sharedToast] hideToast];
                 }
                 if ([url containsString:@"passport/doLogin"]) {
                     ;
                     [Utility saveCookies];

                 }
                 NSLog(@"============================================");
                 NSLog(@"= response");

                 NSLog(@"responseObject ======== %@\n\n\n", responseObject);

                 [self requestSuccessWithUrl:url response:responseObject handler:completionHandler];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if (finished) {
                     finished();
                 }
                 if (judge) {
                     [[YZToastView sharedToast] hideToast];
                 }
                 NSLog(@"errorUrl = %@", fullURLStr);
                 [self requestFailureWithError:error task:task handler:completionHandler];
             }];
    }else if ([method isEqualToString:@"POST"]) {
        // POST Request
        [manager POST:url
           parameters:newParams
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                  if (finished) {
                      finished();
                  }
                  if (judge) {
                      [[YZToastView sharedToast] hideToast];
                  }
                  if ([url containsString:@"passport/doLogin"]) {
                      ;
                      [Utility saveCookies];
                  }
                  NSLog(@"============================================");
                  NSLog(@"= response");
                  NSLog(@"responseObject ======= %@\n\n\n", responseObject);

                  [self requestSuccessWithUrl:url response:responseObject handler:completionHandler];
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if (finished) {
                      finished();
                  }
                  if (judge) {
                      [[YZToastView sharedToast] hideToast];
                  }
                  NSLog(@"errorUrl = %@", fullURLStr);
                  [self requestFailureWithError:error task:task handler:completionHandler];
              }];
    }
}

#pragma mark - requestFile
+ (void)requestWithData:(id)data
                    url:(NSString *)url
             parameters:(id)parameters
      completionHandler:(void (^)(id, NSError *))completionHandler {
    [[YZToastView sharedToast] showToast];
    
    url = [url_base stringByAppendingString:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [(AFJSONResponseSerializer *)manager.responseSerializer setRemovesKeysWithNullValues:YES];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", [DataManager sharedManager].userAgent] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"yz-version"];
    [manager.requestSerializer setValue:[DataManager sharedManager].sessionid forHTTPHeaderField:@"yz-startid"];
    [manager.requestSerializer setValue:[DataManager sharedManager].openUDID forHTTPHeaderField:@"yz-deviceid"];
    
    [manager POST:url
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if (data) {
        for (NSString *key in [data allKeys]) {
        [formData appendPartWithFileData:[data objectForKey:key]
                                    name:key
                                fileName:[NSString stringWithFormat:@"%f.jpeg", [NSDate timeIntervalSinceReferenceDate]]
                                mimeType:@"image/jpeg"];
            }
        }
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
              [[YZToastView sharedToast] hideToast];
              [self requestSuccessWithUrl:url response:responseObject handler:completionHandler];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [[YZToastView sharedToast] hideToast];
              NSLog(@"errorUrl = %@", url);
              [self requestFailureWithError:error task:task handler:completionHandler];
          }];
}
#pragma mark - httpsCertificate
+ (AFSecurityPolicy *)customSecurityPolicyWithValidate:(BOOL)validate {
    if (validate) {
        // 先导入证书
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"yzmoney.com" ofType:@"cer"];//证书的路径
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
        
        securityPolicy.pinnedCertificates = @[certData];
        
        return securityPolicy;
    }
    else {
        // AFSSLPinningModeNone 不使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
        
        return securityPolicy;
    }
}


#pragma mark - handler
+ (void)requestSuccessWithUrl:(NSString *)url
                     response:(id)responseObject
                      handler:(void (^)(id response, NSError *error))completionHandler {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!responseObject) {
        [YZToastView showToastWithText:@"网络不通，请稍后尝试"];
        return;
    }
    if ([responseObject isKindOfClass:[UIImage class]]) {
        completionHandler(responseObject, nil);
        return;
    }
    if (![responseObject[@"success"] boolValue]) {
        NSString *msg = responseObject[@"msg"];
        if (msg.length > 0) {
            [YZToastView showToastWithText: msg];
        }else{
//            [YZToastView showToastWithText: @"未知"];
        }
        return;
    }
    if ([responseObject[@"msgCode"] integerValue] == 0) {
        completionHandler(responseObject, nil);
    }else if ([responseObject[@"msgCode"] integerValue] == 99) {
        [APPDELEGATE.window.rootViewController performSegueWithIdentifier:@"segue_tab_login" sender:nil];
        if ([url containsString:@"productJson"]) {
            completionHandler(nil, nil);
        }
    }else if ([responseObject[@"msgCode"] integerValue] == 98) {
        YZSurveyVC *surveyVC = [[YZSurveyVC alloc] initWithUrl:[responseObject valueForKeyPath:@"data"]];
        [APPDELEGATE.window.rootViewController presentViewController:surveyVC animated:YES completion:nil];
    }else {
        if ([responseObject[@"msgCode"] integerValue] == 100) {
            completionHandler(responseObject, nil);
        }
        NSString *msg = responseObject[@"msg"];
        if (msg.length > 0) {
            [YZToastView showToastWithText: msg];
        }
    }
}

+ (void)requestFailureWithError:(NSError *)error task:(NSURLSessionDataTask *)task
                        handler:(void (^)(id response, NSError *error))completionHandler {
    completionHandler(nil, error);
    NSLog(@"statusCode = %d", (int)((NSHTTPURLResponse *)task.response).statusCode);
    NSLog(@"error ====== %@", error);
     if (error.code == -1001) {
        [YZToastView showToastWithText:@"请求超时"];
    }else {
        if (((NSHTTPURLResponse *)task.response).statusCode == 404) {
            //        [YZToastView showToastWithText:[NSString stringWithFormat:@"request404"]];
        }else{
            [YZToastView showToastWithText:@"网络不通，请稍后尝试"];
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end