//
//  YZPickerView.m
//  YZMoney
//
//  Created by 7仔 on 15/11/24.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZPickerView.h"





@interface YZPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintBottom;

@end





@implementation YZPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    self.frame = window.frame;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
}

- (void)show {
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    _constraintBottom.constant = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hide {
    _constraintBottom.constant = -260.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _titles.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _titles[row];
}


#pragma mark - action

- (void)actionTap:(UITapGestureRecognizer *)sender {
    [self hide];
}

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    [self hide];
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    [self hide];
    _pickerDoneBlock(_titles[[_picker selectedRowInComponent:0]]);
}

@end
