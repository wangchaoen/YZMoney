//
//  Utility.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/2/28.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (BOOL)islogin;
+ (void)goLogin;
+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;

+ (NSString *)md5:(NSString *)str;

+ (CGSize)calculatelblSizeForFont:(CGFloat)font scope:(CGSize)size text:(NSString *)text;

+ (void)MJRefreshHeaderGif:(UIScrollView *)tableView headerWithRefreshingBlock:(void(^)())block;

+ (void)tableViewFooterHiddenWith:(UITableView *)tableView currentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage;

+ (void)setLabelLineSpace:(UILabel *)lbl content:(NSString *)content lineSpace:(CGFloat)lineSpace;

+ (void)updateUserInfoWithVC:(UIViewController *)vc toastText:(NSString *)text finish:(void(^)())finishBlack;

+ (BOOL) validateEmail:(NSString *)email;

+ (BOOL) validateMobile:(NSString *)mobile;

+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//tabBar到第几页
+ (void)tabBarWithIndex:(NSInteger)index;

+ (NSString *)createUUID;
+ (NSString *)currentTime;
+ (NSString *)shuffledAlphabet;

+ (void)saveCookies;
+ (void)loadCookies;
@end
