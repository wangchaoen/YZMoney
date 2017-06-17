//
//  YZHttpClient.h
//  YZMoney
//
//  Created by 7仔 on 15/11/5.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "AFHTTPSessionManager.h"





@interface YZHttpClient : AFHTTPSessionManager

+ (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               parameters:(id)parameters
        completionHandler:(void (^)(id response, NSError *error))completionHandler;

+ (void)requestWithNoToastMethod:(NSString *)method
                             url:(NSString *)url
                      parameters:(id)parameters
               completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(void(^)())finished;

#pragma mark - file
+ (void)requestWithData:(id)data
                    url:(NSString *)url
             parameters:(id)parameters
      completionHandler:(void (^)(id response, NSError *error))completionHandler;

@end
