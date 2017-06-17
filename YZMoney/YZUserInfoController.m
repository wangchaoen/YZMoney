//
//  YZUserInfoController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/7.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZUserInfoController.h"
#import "YZPasswordVC.h"
#import "YZNameController.h"
#import "YZEmailController.h"
#import "YZIntroductionController.h"
#import "VPImageCropperViewController.h"
#import "UIImage+Resizing.h"
#import "UUImageAvatarBrowser.h"
#import "FPCertificationVC.h"


@interface YZUserInfoController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *array;
@end

@implementation YZUserInfoController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self request];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"usercenter_profile"];
    self.navigationItem.title = @"用户设置";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.array = @[@[@"头像", @"用户名", @"邮箱", @"性别", @"个人简介", @"用户认证"], @[@"修改密码", @"退出登录"]];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H)];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = YZ_GRAY_COLOR;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.array[section];
    if (section == 0) {
        return array.count;
    }else {
        return array.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    for (UIView *view in cell.contentView.subviews) {
//        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
//        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = self.array[indexPath.section];
    NSString *str = array[indexPath.row];
    cell.textLabel.text = str;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.section == 0 && indexPath.row == 0) {
//        cell.accessoryType = UITableViewCellAccessoryNone;

        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(S_W - 60 - 30, 20, 60, 60)];
        image.backgroundColor = [UIColor whiteColor];
        image.layer.cornerRadius = 2;
        image.layer.masksToBounds = YES;
        image.layer.borderColor = [UIColor lightGrayColor].CGColor;
        image.layer.borderWidth = 0.5;
        image.userInteractionEnabled = YES;
        [cell.contentView addSubview:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigIcon:)];
        [image addGestureRecognizer:tap];
//        NSString *url = [NSString stringWithFormat:@"%@image/order?id=%@", url_base, yz_user.ID];
//        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loggedin"]];
        NSLog(@"%@", yz_user.iconImage);
        if (yz_user.iconImage) {
            image.image = yz_user.iconImage;
        }else{
            image.image = [UIImage imageNamed:@"loggedin"];
        }
        return cell;
    }
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(S_W - 30 - 150, 10, 150, 20)];
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lbl];
    
    if (indexPath.section == 0) {
         if (indexPath.row == 1){
            //用户名
             lbl.text = yz_user.nickname;
        }else if (indexPath.row == 2){
            //邮件
            lbl.text = yz_user.email;
        }else if (indexPath.row == 3){
            //性别
            lbl.text = yz_user.genderView;
        }else if (indexPath.row == 4){
            //个人简介
            lbl.text = yz_user.descriptions;
        }else {
            if (yz_user.verifyStatusView) {
                lbl.text = yz_user.verifyStatusView;
            }else {
                lbl.text = @"";
            }
        }
    }else {
        if (indexPath.row == 0) {
            //忘记密码
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            //退出登录
        }
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //头像
            [self updateUserIcon];
        }else if (indexPath.row == 1){
            //用户名
            YZNameController *vc = [[YZNameController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            //邮件
            YZEmailController *vc = [[YZEmailController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            //性别
            
            [self chooseGender];
        }else if (indexPath.row == 4){
            //个人简介
            YZIntroductionController *vc = [[YZIntroductionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //用户认证
                NSInteger i = yz_user.verifyStatus;
//                0表示未认证
//                1表示认证中
//                2表示已认证
//                3表示认证失败
                    FPCertificationVC *vc = [[FPCertificationVC alloc]init];
                    vc.comeType = i;
                    [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        if (indexPath.row == 0) {
            //忘记密码
            YZPasswordVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YZPasswordVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //退出登录
            [self exitLogin];
        }
    }
}
#pragma mark - uiimageDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WEAK_SELF;
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        VPImageCropperViewController *imgCropperVC =
        [[VPImageCropperViewController alloc] initWithImage:image
                                                  cropFrame:CGRectMake(0, (S_H - S_W) * 0.5f, S_W, S_W)
                                            limitScaleRatio:3.0];
        imgCropperVC.delegate = weakSelf;
        [weakSelf presentViewController:imgCropperVC animated:YES completion:nil];
    }];
    
}
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (editedImage.size.width > 750) {
        editedImage = [editedImage scaleToSize:CGSizeMake(750, 750)];
    }
    BOOL judge = [YZCacheHelper saveImageDocuments:editedImage];
    if (judge) {
        [YZToastView showToastWithText:@"修改头像成功"];
        yz_user.iconImage = editedImage;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//        NSLog(@"%@", yz_user.iconImage);
    }
    
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Utils
- (void)request {
    WEAK_SELF;
    [YZHttpApiManager apiUserWithParameters:nil
                          completionHandler:^(id response, NSError *error) {
                              if (response) {
                                  yz_user = [[YZUserModel alloc]initWithDict:[response valueForKeyPath:@"data.memberData"]];
                                  [YZCacheHelper cacheObject:yz_user file:@"user"];
                                  
                              }else {
                                  yz_user = [YZCacheHelper objectCachedWithFile:@"user"];
                              }
                              yz_user.iconImage = [YZCacheHelper getDocumentImage];
                              
                              [weakSelf.tableView reloadData];
                          } finished:^{
                              
                          }];
}
- (void)updateUserIcon {
    WEAK_SELF;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消"
                                           style:UIAlertActionStyleCancel
                                         handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"拍照"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                     
                                             if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                 return;
                                             }   UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                             imagePickerController.delegate = weakSelf;
                                             imagePickerController.allowsEditing = NO;
                                             imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                             
                                             [weakSelf presentViewController:imagePickerController animated:YES completion:nil];

                                             
                                             
                                         }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"从手机相册中选择"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                            
                                             if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                 return;
                                             }
                                             UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                                                          imagePickerController.delegate = weakSelf;
                                             imagePickerController.allowsEditing = NO;
                                             imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                             
                                             [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                                         }]];
    [self presentViewController:ac animated:YES completion:nil];
}
- (void)chooseGender {
    WEAK_SELF;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消"
                                           style:UIAlertActionStyleCancel
                                         handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"保密"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             [weakSelf updateGenderWith:@0];
                                         }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"男"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                        [weakSelf updateGenderWith:@1];
                                         }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"女"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                          [weakSelf updateGenderWith:@2];
                                         }]];
    [self presentViewController:ac animated:YES completion:nil];
}
- (void)updateGenderWith:(NSNumber *)gender {
    yz_user.gender = [gender integerValue];
    WEAK_SELF;
//    yz_user.detail = @{
//                       @"description" : yz_user.detail[@"description"]?:@"",
//                       @"gender": gender,
//                       @"address": yz_user.detail[@"address"]?:@"",
//                       @"vocation":  yz_user.detail[@"vocation"]?:@""
//                       };
    [Utility updateUserInfoWithVC:nil toastText:@"修改性别成功" finish:^{
        [weakSelf request];
    }];
}
- (void)exitLogin {
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
                                                                         [Utility tabBarWithIndex:0];                                                                     }];
                                         }]];
    [self presentViewController:ac animated:YES completion:nil];

}
#pragma mark - action 
- (void)showBigIcon:(UITapGestureRecognizer *)tap {
    if (yz_user.iconImage) {
        [UUImageAvatarBrowser showImage:(UIImageView *)tap.view];
    }
}
@end
