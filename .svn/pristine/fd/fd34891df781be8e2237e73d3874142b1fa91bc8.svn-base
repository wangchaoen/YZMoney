//
//  YZNameController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/10.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZNameController.h"

@interface YZNameController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation YZNameController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated {
    [self.textField becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YZ_GRAY_COLOR;
    self.navigationItem.title = @"昵称";
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 20, S_W, 45)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.textField];
    
    self.textField.text = yz_user.nickname;
    
    UIBarButtonItem *sumbitBut = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(sumbitButAction)];
    
    [sumbitBut setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = sumbitBut;
    
}
- (UITextField *)textField{
    if (!_textField) {
    
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64 + 20, S_W - 20, 45)];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
    
}

- (void)sumbitButAction {
    [self.textField resignFirstResponder];
    if (self.textField.text.length <= 0) {
        [YZToastView showToastWithText:@"请输入你的昵称"];
        return;
    }
    if (self.textField.text.length > 25) {
        [YZToastView showToastWithText:@"昵称在25个字以内"];
        return;
    }
    yz_user.nickname = self.textField.text;
    [Utility updateUserInfoWithVC:self toastText:@"修改昵称成功" finish:nil];
}

@end
