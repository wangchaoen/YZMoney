//
//  YZMineVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/13.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZMineVC.h"
#import "YZClientListVC.h"
#import "YZMineServiceVC.h"
#import "YZActionSheet.h"
#import "YZNewsDetailVC.h"
#import "UIImage+ImageWithColor.h"
#import "YZMineSettingVC.h"
#import "YZMineAppointListVC.h"
#import "YZMineStateCell.h"
#import "YZMineFavoriteVC.h"
#import "YZMineTitleView.h"
#import "OtherSettController.h"
#import "YZUserInfoController.h"
#import "FeedbackController.h"
#import "YZContractController.h"
#import "YZMineTypeController.h"
#import "YZMineBut.h"


@interface YZMineVC ()<YZMineStateCellDelegate>

@property (nonatomic, copy) NSDictionary *dicSurvey;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YZMineTitleView *titleView;
@property (nonatomic, strong) NSMutableArray *numberArray;

@property (nonatomic, assign, getter = isStateWhite) BOOL stateWhite;
@property (nonatomic, assign) BOOL atView;
@end





@implementation YZMineVC
- (void)viewWillAppear:(BOOL)animated {
    [MobClick event:@"index_dock" label:@"/user"];
    self.atView = YES;
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (ISLOGIN) {
        [self requesWithUserStatus];
        [self.titleView isLogin];
    }
    
    if (self.isStateWhite) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }else {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.atView = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, -20, S_W, S_H + 20);
}
- (void)isLoginDataArrayMember {
    self.dataArray =[NSMutableArray arrayWithArray:@[
                                                     @[@{@"image": @"", @"title": @"我的订单"}],
                                                     @[@{@"title": ISLOGIN ? @[@"预约待审核", @"预约成功", @"报单待审核", @"报单成功", @"合同申请", @"我的客户", @"我的收藏", @"个人问卷"] : @[@"合同申请", @"我的客户", @"我的收藏", @"个人问卷"]}],
                                                     @[
//  @{@"title": @"个人问卷", @"image": @"personquestion_icon"},
                                                       @{@"title": @"邀请好友", @"image": @"invitation"},
                                                       @{@"title": @"其他设置", @"image": @"setting_icon"},
                                                       @{@"title": @"意见反馈", @"image": @"feedback_icon"},
                                                       @{@"title": @"应用评分", @"image": @"good_icon"}
                                                       ]
                                                     ]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateWhite = YES;
    self.numberArray = [NSMutableArray array];
    [self isLoginDataArrayMember];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasGet:) name:kUserHasGet object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasRemove:) name:kUserHasRemove object:nil];
    
    [YZHttpApiManager apiMineSurveyWithParameters:nil
                                completionHandler:^(id response, NSError *error) {
                                    _dicSurvey = [[response valueForKeyPath:@"data.menuList"] firstObject];
                                }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    YZMineTitleView *titleView = [[YZMineTitleView alloc]initWithFrame:CGRectMake(0, 0, S_W, 120)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingAction)];
    [titleView addGestureRecognizer:tap];
    self.titleView = titleView;
    if (yz_user) {
        [titleView isLogin];
    }else {
        [titleView notLogin];
    }
    titleView.backgroundColor = YZ_RED_COLOR;
    self.tableView.tableHeaderView = titleView;
    [self.tableView registerClass:[YZMineStateCell class] forCellReuseIdentifier:NSStringFromClass([YZMineStateCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}
#pragma mark - Notification
- (void)userHasGet:(NSNotification *)noti {
    [self isLoginDataArrayMember];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.titleView isLogin];
    [self requesWithUserStatus];
    
}
- (void)userHasRemove:(NSNotification *)noti {
    [self isLoginDataArrayMember];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.titleView notLogin];
}
#pragma mark - Utils
- (void)requesWithUserStatus {
    WEAK_SELF;
    [YZHttpApiManager apiMineGetUserStatusWithParameters:@{@"orderStatus": @"1|2", @"bookingStatus": @"0|1"} completionHandler:^(id response, NSError *error) {
        if (response) {
            [weakSelf.numberArray removeAllObjects];
            NSDictionary *data = response[@"data"];
            NSDictionary *bookingCount = data[@"bookingCount"];
            NSDictionary *orderCount = data[@"orderCount"];
            NSString *pendingBooking = @"";
            NSString *successBooking = @"";
            NSString *pendingOrder = @"";
            NSString *successOrder = @"";
            for (NSString *key in bookingCount.allKeys) {
                if ([key isEqualToString:@"pendingBooking"]) {
                    pendingBooking = [bookingCount[key] stringValue];
                }else{
                    successBooking = [bookingCount[key] stringValue];
                }
            }
            for (NSString *key in orderCount.allKeys) {
                if ([key isEqualToString:@"pendingOrder"]) {
                    pendingOrder = [orderCount[key] stringValue];
                }else{
                    successOrder = [orderCount[key] stringValue];
                }
            }
            [weakSelf.numberArray addObject:pendingBooking];
            [weakSelf.numberArray addObject:successBooking];
            [weakSelf.numberArray addObject:pendingOrder];
            [weakSelf.numberArray addObject:successOrder];
            [weakSelf.tableView reloadData];
        }
    } finished:^{
        
    }];
}
- (void)pushSpecifiedOrderList:(NSString *)title dic:(NSDictionary *)dic {
    YZMineTypeController *vc = [[YZMineTypeController alloc]init];
    vc.parameters = dic;
    vc.title = title;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - table view
//NSIndexPath *path =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
//UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.atView) {
        return;
    }
    if (scrollView.contentOffset.y > 90) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.stateWhite = NO;
    }else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.stateWhite = YES;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? (ISLOGIN ? 140.0f : 70) : 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    if (indexPath.section == 1) {
        YZMineStateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZMineStateCell class])];
        [cell createViewWithArray:dic[@"title"] number:self.numberArray];
        cell.delegate = self;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.font = MidFont;
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(S_W - 90, 0, 70, 50)];
        lbl.text = @"所有订单";
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbl];
    }else {
        UIButton *lineView = [[UIButton alloc]initWithFrame:CGRectMake(0, 49, S_W, 1)];
        lineView.alpha = 0.5;
        lineView.backgroundColor = YZ_GRAY_COLOR;
        [cell.contentView addSubview:lineView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if (indexPath.section == 0) {
        [MobClick event:@"usercenter_myorder"];
        if (!ISLOGIN) {
            [Utility goLogin];
            return;
        }
        YZMineAppointListVC *vc  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YZMineAppointListVC"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){

    }else {
        if (indexPath.row == 0) {
            //邀请好友
            if (!ISLOGIN) {
                [Utility goLogin];
                return;
            }
            [MobClick event:@"usercenter_invite"];
            [self sendAuthRequest];
        }else if (indexPath.row == 1) {
            //其他设置
            [MobClick event:@"usercenter_setting"];
            OtherSettController *vc = [[OtherSettController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {
            //意见反馈
            FeedbackController *vc = [[FeedbackController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3) {
            //评价
            NSString *str = @"http://itunes.apple.com/cn/app/id1068466686";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
#pragma mark - action 
- (void)settingAction {
    if (!ISLOGIN) {
        [Utility goLogin];
        return;
    }
    YZUserInfoController *vc = [[YZUserInfoController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - customDelegate
- (void)touchButActionWithCell:(YZMineStateCell *)cell button:(UIButton *)but {
    YZMineBut *button = (YZMineBut *)but;
    if (!ISLOGIN) {
        [Utility goLogin];
        return;
    }
        switch (but.tag) {
        case 0:
            [self pushSpecifiedOrderList:button.lbl.text dic:@{@"bookingType": @"0,10"}];
            break;
        case 1:
            [self pushSpecifiedOrderList:button.lbl.text dic:@{@"bookingType": @"1"}];
            break;
        case 2:
            [self pushSpecifiedOrderList:button.lbl.text dic:@{@"orderType": @"1"}];
            break;
        case 3:
            [self pushSpecifiedOrderList:button.lbl.text dic:@{@"orderType": @"2"}];
            break;
            case 4:{
                YZContractController *vc = [[YZContractController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        case 5:{
            // 我的客户
            [MobClick event:@"usercenter_myclient"];
            YZClientListVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YZClientListVC"];
            vc.type = YZClientListTypeMine;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:{
            // 收藏
            [MobClick event:@"usercenter_myfavorite"];
            YZMineFavoriteVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YZMineFavoriteVC"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 7:{
                // 个人问卷
                YZNewsDetailVC *newsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_news"];
                newsVC.title = @"个人问卷";
                newsVC.url = [_dicSurvey valueForKeyPath:@"link"];
                if (!newsVC.url) {
                    return;
                }
                newsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newsVC animated:YES];
            }
                break;
        default:
            break;
    }
}

#pragma mark - wx

- (void)sendAuthRequest {
    SendAuthReq *req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
        [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", [DataManager sharedManager].isWChat2 ? WChatKey2 : WChatKey, [DataManager sharedManager].isWChat2 ? WChatAppSecret2 : WChatAppSecret,[(SendAuthResp *)resp code]]
          parameters:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                 [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",responseObject[@"access_token"],responseObject[@"openid"]]
                   parameters:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                          if (!responseObject[@"errcode"]) {
                              YZActionSheet *as = [[YZActionSheet alloc] initWithID:nil
                                                                            arrMore:nil
                                                                           arrShare:@[@"微信好友", @"朋友圈"]];
                              as.shareUrl = [NSString stringWithFormat:@"%@passport/register?inviter=%@",url_h5,yz_user.ID];
                              as.shareTitle = [NSString stringWithFormat:@"%@邀请您加入 亿金融-理财师服务平台！",responseObject[@"nickname"]?[NSString stringWithFormat:@"%@ ",responseObject[@"nickname"]]:@""];
                              as.shareContent = @"亿金融产品多、佣金高、结算快、服务好、信誉高。信托、资管、私募、PE/VC、债券等理财产品充分满足您的需要。";
                              as.shareImage = responseObject[@"headimgurl"]?[NSData dataWithContentsOfURL:[NSURL URLWithString:responseObject[@"headimgurl"]]]:[UIImage imageNamed:@"80.png"];
                              as.black = ^(NSInteger i){
                                  if (i == 0) {
                                      [MobClick event:@"usercenter_invite_wechat"];
                                  }else{
                                      [MobClick event:@"usercenter_invite_cycle"];
                                  }
                              };
                              
                              [as show];
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
    }
}
@end
