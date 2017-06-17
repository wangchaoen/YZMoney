//
//  YZEmailView.m
//  YZMoney
//
//  Created by 7仔 on 15/11/27.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZEmailView.h"





@interface YZEmailView ()

@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCenterY;

@end





@implementation YZEmailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
    [self addGestureRecognizer:tap];
}

- (void)keyboardDidShow:(NSNotification *)noti {
    CGSize kbSize = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (kbSize.height > CGRectGetHeight([[UIScreen mainScreen] bounds])/2-50.0f) {
        _constraintCenterY.constant = -kbSize.height+CGRectGetHeight([[UIScreen mainScreen] bounds])/2-50.0f;
    }
}

- (void)keyboardDidHide:(NSNotification *)noti {
    _constraintCenterY.constant = 0.0f;
}


#pragma mark - action

- (IBAction)actionCancel:(UIButton *)sender {
    [self cancel];
}
- (void)cancel {
    WEAK_SELF;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (IBAction)actionDone:(UIButton *)sender {
    if (_tfEmail.text.length) {
        [MobClick event:@"detail_mail_send"];
        [YZHttpApiManager apiProductEmailWithParameters:@{@"pid" : _idProduct,
                                                          @"email" : _tfEmail.text}
                                      completionHandler:^(id response, NSError *error) {
                                          [self removeFromSuperview];
                                          [YZToastView showToastWithText:@"发送成功"];
                                          
                                          [MobClick event:@"mailDetail_send" label:@"邮件"];
                                      }];
    }
}
@end
