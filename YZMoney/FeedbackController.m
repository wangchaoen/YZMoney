//
//  FeedbackController.m
//  tsz
//
//  Created by 王朝恩 on 16/3/10.
//  Copyright © 2016年 arthur. All rights reserved.
//

#define ZSYPING_Y(A) A* S_H / 568
#define ZSYPING_X(B) B* S_W / 320

#import "UILabel+MyLabel.h"
#import "FeedbackController.h"

@interface FeedbackController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation FeedbackController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    scrollView.scrollEnabled = NO;
    self.scrollView = scrollView;
    self.scrollView.contentSize = CGSizeMake(0, S_H - 64);
    [self.view addSubview:self.scrollView];

    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = YZ_GRAY_COLOR;
    [self createRightButton];
    
    UILabel *titleLabel = [UILabel createLabelRect:CGRectMake(10, 10, S_W - 20, 40)
                                     textAlignment:NSTextAlignmentLeft
                                              font:[UIFont systemFontOfSize:(14)]
                                         backColor:[UIColor clearColor]
                                         textColor:[UIColor blackColor]];
    titleLabel.numberOfLines = 0;
    [Utility setLabelLineSpace:titleLabel content:@"感谢你提出宝贵意见和建议，你留下的每个字都将用来改善我们的产品" lineSpace:4];
    [self.scrollView addSubview:titleLabel];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ZSYPING_Y(60), S_W, ZSYPING_Y(180))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bgView];
    [self.scrollView addSubview:self.textView];
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame) + ZSYPING_Y(10), S_W, 45)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:bgView];
    }
    [self.scrollView addSubview:self.textField];
    [self.textView addSubview:self.placeholderLabel];
    if ([self checkPhoneNumber: yz_user.mobile]) {
        self.textField.text = yz_user.mobile;
    }
}

- (void)createRightButton{
    UIBarButtonItem *barBut = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    self.navigationItem.rightBarButtonItem = barBut;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(ZSYPING_X(10), ZSYPING_Y(60), S_W - ZSYPING_Y(20), ZSYPING_Y(180))];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:(14)];
        _textView.delegate = self;
    }
    return _textView;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(ZSYPING_Y(12), CGRectGetMaxY(self.textView.frame) + ZSYPING_Y(10), S_W - ZSYPING_Y(22), 45)];
        _textField.font = [UIFont systemFontOfSize:(14)];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.placeholder = @"联系方式";
    }
    return _textField;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel createLabelRect:CGRectMake(ZSYPING_X(2), ZSYPING_Y(8), CGRectGetWidth(self.textView.frame) - ZSYPING_X(4), ZSYPING_Y(13)) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:(15)] backColor:[UIColor clearColor] textColor:RGBColor(180, 180, 180, 1)];
        _placeholderLabel.text = @"用的不爽，说两句噢...";
        _placeholderLabel.alpha = .6;
        
    }
    return _placeholderLabel;
}

//提交
- (void)submitAction{
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    NSString *str = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.textView.text.length < 10 || self.textView.text.length > 500 || str.length <= 0) {
        [YZToastView showToastWithText:@"请输入您的意见反馈，10个字以上"];
    }else{
        WEAK_SELF;
        [YZHttpApiManager apiMineUserFeedBackWithParameters:@{@"suggestText": self.textView, @"suggestTel": self.textField.text ? : @""} completionHandler:^(id response, NSError *error) {
            if (response) {
                if ([[response objectForKey:@"code"] integerValue] == 0) {
                    [YZToastView showToastWithText:@"谢谢您的意见和建议！"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        } finished:^{
            
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (str.length > 500) {
        textView.text = [str substringToIndex:500];
        return NO;
    }
    return YES;
}
- (BOOL)checkPhoneNumber:(NSString *)phone {
    NSRange range = [phone rangeOfString:@"^1[34578]\\d{9}$" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return NO;
    }
    return YES;
}


@end
