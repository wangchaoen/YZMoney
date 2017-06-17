//
//  YZIntroductionController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/10.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZIntroductionController.h"

@interface YZIntroductionController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation YZIntroductionController
- (void)viewDidAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZ_GRAY_COLOR;
    self.navigationItem.title = @"个人简介";
    UIBarButtonItem *barBut = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(sumbitButAction)];
    [barBut setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barBut;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + 64, S_W, 120)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self.view addSubview:self.textView];
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 20 + 64, S_W - 20, 120)];
        [_textView setBackgroundColor:[UIColor whiteColor]];
        _textView.text = yz_user.descriptions;
        _textView.font = [UIFont systemFontOfSize:14];
//        _textView.delegate = self;
    }
    return _textView;
}
- (void)sumbitButAction {
    [self.textView resignFirstResponder];
//    if (self.textView.text.length <= 0) {
//        [YZToastView showToastWithText:@"请输入你的简介"];
//        return;
//    }
    if (self.textView.text.length > 200) {
        [YZToastView showToastWithText:@"简介在200字以内"];
        return;
    }
    yz_user.descriptions = self.textView.text;
//    yz_user.detail = @{
//                       @"description" : self.textView.text ? : @"",
//                       @"gender": yz_user.detail[@"gender"]?@([yz_user.detail[@"gender"] integerValue]) : @0,
//                       @"address": yz_user.detail[@"address"]?:@"",
//                       @"vocation":  yz_user.detail[@"vocation"]?:@""
//                       };
    [Utility updateUserInfoWithVC:self toastText:@"修改个人简介成功" finish:nil];
}


@end