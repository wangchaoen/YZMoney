//
//  YZProfileEditVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/16.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZMineProfileEditVC.h"





@interface YZMineProfileEditVC () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dicUser;
@property (nonatomic, assign) BOOL editingTV;

@end





@implementation YZMineProfileEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
//    _dicUser = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname"   : yz_user.nickname,
//                                                               @"email"      : yz_user.email[@"value"]?:@"",
//                                                               @"gender"     : yz_user.detail[@"gender"]?@([yz_user.detail[@"gender"] integerValue]):@(0),
//                                                               @"address"    : yz_user.detail[@"address"]?:@"",
//                                                               @"vocation"   : yz_user.detail[@"vocation"]?:@"",
//                                                               @"description": yz_user.detail[@"description"]?:@"",
//                                                               @"age"        : @(0)}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - notification

- (void)keyboardDidShow:(NSNotification *)noti {
    CGSize kbSize = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _tableView.frame = CGRectMake(CGRectGetMinX(_tableView.frame), CGRectGetMinY(_tableView.frame),
                                  CGRectGetWidth(_tableView.frame), CGRectGetHeight(self.view.frame)-64.0f-kbSize.height);
    
    if (_editingTV) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)keyboardDidHide:(NSNotification *)noti {
    _tableView.frame = CGRectMake(CGRectGetMinX(_tableView.frame), CGRectGetMinY(_tableView.frame),
                                  CGRectGetWidth(_tableView.frame), CGRectGetHeight(self.view.frame)-64.0f);
}


#pragma mark - action

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    [YZHttpApiManager apiUserEditWithParameters:_dicUser
                              completionHandler:^(id response, NSError *error) {
                                  [self dismissViewControllerAnimated:YES completion:^{
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kUserShouldGet object:nil];
                                  }];
                              }];
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row==6 ? 160.0f : 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_name"];
            [(UITextField *)[cell viewWithTag:1] setText:_dicUser[@"nickname"]];
            [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_name"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_mobile"];
            [(UILabel *)[cell viewWithTag:1] setText:yz_user.mobile];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_email"];
            [(UITextField *)[cell viewWithTag:1] setText:_dicUser[@"email"]];
            [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_email"];
            break;
        case 3: {
            NSArray *arr = @[@"保密", @"男", @"女"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_gender"];
            [(UILabel *)[cell viewWithTag:1] setText:arr[[_dicUser[@"gender"] integerValue]]];
            break;
        }
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
            [(UITextField *)[cell viewWithTag:1] setText:_dicUser[@"address"]];
            [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_address"];
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_carrer"];
            [(UITextField *)[cell viewWithTag:1] setText:_dicUser[@"vocation"]];
            [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_carrer"];
            break;
        case 6:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_description"];
            [(UITextView *)[cell viewWithTag:1] setText:_dicUser[@"description"]];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 3) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"保密", @"男", @"女", nil];
        [as showInView:self.view];
    }
}


#pragma mark - action

- (void)actionTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (IBAction)actionEditingChanged:(UITextField *)sender {
    NSString *marked = [sender textInRange:sender.markedTextRange];
    if (!marked.length) {
        if ([sender.accessibilityIdentifier isEqualToString:@"tf_name"]) {
            [_dicUser setValue:sender.text forKey:@"nickname"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_email"]) {
            [_dicUser setValue:sender.text forKey:@"email"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_address"]) {
            [_dicUser setValue:sender.text forKey:@"address"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_carrer"]) {
            [_dicUser setValue:sender.text forKey:@"vocation"];
        }
    }
}


#pragma mark - delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray *arr = @[@"保密", @"男", @"女"];
    if (buttonIndex < arr.count) {
        [_dicUser setValue:@(buttonIndex) forKey:@"gender"];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *marked = [textView textInRange:textView.markedTextRange];
    if (!marked.length) {
        [_dicUser setValue:textView.text forKey:@"description"];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _editingTV = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _editingTV = NO;
}

@end
