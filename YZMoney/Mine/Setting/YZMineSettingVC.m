
//
//  YZMineSettingVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/20.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZMineSettingVC.h"
#import "YZNewsDetailVC.h"





@interface YZMineSettingVC ()

@end





@implementation YZMineSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return yz_user ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_profile"];
            }
            else if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_password"];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_about"];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_logout"];
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if (indexPath.section==0 && !yz_user) {
        [self.tabBarController performSegueWithIdentifier:@"segue_tab_login" sender:nil];
    }
    else if (indexPath.section == 2) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                    message:@"是否注销当前用户"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [YZHttpApiManager apiLogoutWithParameters:nil
                                                                         completionHandler:^(id response, NSError *error) {
                                                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:kUserShouldRemove object:nil];
                                                                             [self.navigationController popToRootViewControllerAnimated:NO];
                                                                             [Utility tabBarWithIndex:0];

                                                                         }];
                                             }]];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    if (indexPath.section==0 && indexPath.row==0) {
        [MobClick event:@"settingUser_profile"];
    }
    else if (indexPath.section==0 && indexPath.row==1) {
        [MobClick event:@"settingUser_password"];
    }
}


#pragma mark - segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"segue_setting_about"]) {
        return YES;
    }
    return yz_user ? YES : NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_setting_about"]) {
        [(YZNewsDetailVC *)segue.destinationViewController setUrl:[NSString stringWithFormat:@"%@aboutUs", url_base]];
        [(YZNewsDetailVC *)segue.destinationViewController setTitle:@"关于亿金融"];
    }
}

@end
