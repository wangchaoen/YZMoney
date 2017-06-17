//
//  YZHttpApiManager.m
//  YZMoney
//
//  Created by 7仔 on 15/11/5.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZHttpApiManager.h"





@implementation YZHttpApiManager
#pragma mark - APPDelegate
+ (void)apiTabBarIndexWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                       url:@"open/column/getHomeColumn"
                                parameters:parameters
                         completionHandler:^(id response, NSError *error) {
                             completionHandler(response, error);
                         } finished:finished];
}
+ (void)apiWChatIDWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                       url:@"myCenter/findAppId"
                                parameters:parameters
                         completionHandler:^(id response, NSError *error) {
                             completionHandler(response, error);
                         } finished:finished];
}
#pragma mark - user

+ (void)apiUserWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(void(^)())finished{
    [YZHttpClient requestWithNoToastMethod:@"GET"
                                url:@"myCenter/userInfo"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}

+ (void)apiUserEditWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/info/submit"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


#pragma mark - register & login & logout & password

+ (void)apiCodeWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"code/register"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiCodeCenterWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"code/center"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiCodePasswordWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"code/password"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiRegisterWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"passport/doRegister"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiLoginWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"passport/doLogin"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiLogoutWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"passport/ajaxLogout"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiDoPasswordWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"passport/doPassword"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiUpPasswordWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/pwd/submit"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiCheckCodeWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"GET"
                                url:@"checkcode"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}


#pragma mark - index
+ (void)apiIndexColumnWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                       url:@"open/column/listColumns"
                                parameters:parameters
                         completionHandler:^(id response, NSError *error) {
                             completionHandler(response, error);
                         } finished:finished];
}
+ (void)apiIndexWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"GET"
                                url:@"index"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}

+ (void)apiHotProductWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"open/product/hot"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


#pragma mark - product

+ (void)apiProductCategoryWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"open/product/tabList"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductListWithParameters:(id)parameters url:(NSString *)url completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"GET" url:url parameters:parameters completionHandler:^(id response, NSError *error) {
        completionHandler(response, error);
    } finished:finished];
//    [YZHttpClient requestWithMethod:@"GET"
//                                url:@"productJson"
//                         parameters:parameters
//                  completionHandler:^(id response, NSError *error) {
//                             completionHandler(response, error);
//                         }];
}

+ (void)apiProductConditionWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {

    [YZHttpClient requestWithMethod:@"POST"
                                url:@"open/product/listFilterItems"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"product/asynDetail"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductProfitWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/ajaxExpectedIncome"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductAppointWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/bookingSubmit"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductEmailWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"ajaxEmail"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductIsFavoriteWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"product/asyncLoad"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductFavoriteWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/favorite/delete"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiProductDocumentWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"product/fileList"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


#pragma mark - news

+ (void)apiNewsCategoryWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"article/tabList"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiNewsListWithParameters:(id)parameters url:(NSString *)url completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:url
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}

+ (void)apiNewsDetailWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"article/json/d"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


#pragma mark - search
+ (void)apiSearchCategoryHotAndLabelWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"search/index"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}
+ (void)apiSearchCategorySearchCompanyWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"search/company"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}
+ (void)apiSearchCategorySearchLabelWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                       url:@"search/tag"
                                parameters:parameters
                         completionHandler:^(id response, NSError *error) {
                             completionHandler(response, error);
                         } finished:finished];
}

+ (void)apiSearchCategoryWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"loadSearchType"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiSearchListWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST" url:@"search/submit" parameters:parameters completionHandler:^(id response, NSError *error) {
        completionHandler(response, error);
    } finished:finished];
//    [YZHttpClient requestWithMethod:@"POST"
//                                url:@"searchSubmit"
//                         parameters:parameters
//                  completionHandler:^(id response, NSError *error) {
//                      completionHandler(response, error);
//                  }];
}

//联想词
+ (void)apiSearchLenovoWordWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"product/search"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}

#pragma mark - client

+ (void)apiClientDetailWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"member/customer/detail"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiClientListWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/customer/list"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiClientSubmitWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/customer/submit"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiClientDeleteWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/customer/delete"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiClientSearchWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/customer/list"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


#pragma mark - mine
+ (void)apiMineUserFeedBackWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                       url:@"myCenter//suggest"
                                parameters:parameters
                         completionHandler:^(id response, NSError *error) {
                             completionHandler(response, error);
                         } finished:finished];
}
+ (void)apiMineGetUserStatusWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"member/order/centerCount"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}
+ (void)apiMineAppointListWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"member/order/list"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiMineAppointDetailWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/detail"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiMineAppointPictureWithParameters:(id)parameters data:(id)data completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithData:data
                              url:@"member/order/orderSave"
                       parameters:parameters
                completionHandler:^(id response, NSError *error) {
                    completionHandler(response, error);
                }];
}

+ (void)apiMineAppointSearchWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(finishBlock)finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"member/order/list"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}

+ (void)apiMineAppointConditionWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"member/order/condition"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
+ (void)apiMineAppointImageDeleteWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/deletePic"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


+ (void)apiMineFavoriteWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"member/favorite/list"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiMineSurveyWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"myCenter/menu"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiMineServiceWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"callService"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiMineServiceSubmitWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"callService/submit"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
//合同提交
+ (void)apiMineSubmitContractWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/compact/applyCompact"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
// 合同地址列表
+ (void)apiMineContractAddressListWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler finished:(void(^)())finished{
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"member/compact/address/list"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:finished];
}
    //删除地址
+ (void)apiMineContractAddressRemoveWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
        [YZHttpClient requestWithMethod:@"POST"
                                    url:@"member/compact/address/delete"
                             parameters:parameters
                      completionHandler:^(id response, NSError *error) {
                          completionHandler(response, error);
                      }];
}
//获取默认地址
+ (void)apiMineContractGetDefaultAddressWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/compact/address/default"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
//新建地址
+ (void)apiMineContractAddAddressWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/compact/address/save"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
//编辑地址
+ (void)apiMineContractEditorAddressWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/compact/address/update"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
//查看进度
+ (void)apiMineContractLookProgressWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/compact/apply/progress"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}
//提交认证
+ (void)apiMineSubmitCertificationWithParameters:(id)parameters data:(id)data completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithData:data url:@"verify/submit" parameters:parameters completionHandler:^(id response, NSError *error) {
        completionHandler(response, error);
    }];
}


#pragma mark - order

+ (void)apiOrderCancelBookingWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/ajaxCancelBooking"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiOrderCancelOrderWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/ajaxCancelOrder"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiOrderDeleteBookingWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/deleteBooking"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

+ (void)apiOrderOrderSubmitWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"POST"
                                url:@"member/order/orderSubmit"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}


#pragma mark - other

+ (void)apiConfigureWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithNoToastMethod:@"POST"
                                url:@"edition/checkupdate"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:^{
                      
                  }];
}

+ (void)apiBootadWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithNoToastMethod:@"GET"
                                url:@"bootAd"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  } finished:^{
                      
                  }];
}

+ (void)apiSurveyWithParameters:(id)parameters completionHandler:(void (^)(id response, NSError *error))completionHandler {
    [YZHttpClient requestWithMethod:@"GET"
                                url:@"questionnaire/check"
                         parameters:parameters
                  completionHandler:^(id response, NSError *error) {
                      completionHandler(response, error);
                  }];
}

@end
