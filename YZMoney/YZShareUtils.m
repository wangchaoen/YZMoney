//
//  YZShareUtils.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/5.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZShareUtils.h"

@implementation YZShareUtils
+ (void)wchatShareActionWithUrl:(NSString *)url shareTitle:(NSString *)title content:(NSString *)content image:(id)image type:(WChatShareType)type{
    [MobClick event:@"detail_share" label:type == WChatShareTypeFriend ? @"微信好友" : @"微信朋友圈"];
    if (type == WChatShareTypeFriend) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url   = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    }else {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url   = url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    }
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[type == WChatShareTypeFriend ? UMShareToWechatSession : UMShareToWechatTimeline]
                                                       content:content
                                                         image:image
                                                      location:nil
                                                   urlResource:nil
                                           presentedController:nil
                                                    completion:^(UMSocialResponseEntity *response){
                                                        
                                                    }];
}
@end
