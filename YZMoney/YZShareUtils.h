//
//  YZShareUtils.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/5.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WChatShareType){
    
    WChatShareTypeFriend = 0,
    WChatShareTypeGroup
};

@interface YZShareUtils : NSObject
+ (void)wchatShareActionWithUrl:(NSString *)url shareTitle:(NSString *)title content:(NSString *)content image:(id)image type:(WChatShareType)type;
@end
