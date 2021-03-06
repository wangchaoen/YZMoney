//
//  YZClientEditVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/17.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZClientEditVC.h"





@interface YZClientEditVC () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dicClient;
@property (nonatomic, assign) BOOL editingTV;

@end





@implementation YZClientEditVC
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
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
    
    _dicClient = [NSMutableDictionary dictionaryWithDictionary:@{@"id"          : _client.ID?:@"",
                                                                 @"customerType": _client.customerType?@(_client.customerType):@(0),
                                                                 @"customerName": _client.customerName,
                                                                 @"identifyType": @(_client.identifyType),
                                                                 @"identifyNo"  : _client.identifyNo,
                                                                 @"phoneNo"     : _client.phoneNo,
                                                                 @"email"       : _client.email,
                                                                 @"age"         : @(0),
                                                                 @"gender"      : _client.gender?@(_client.gender):@(0),
                                                                 @"address"     : _client.address?:@"",
                                                                 @"memo"        : _client.memo?:@""}];
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
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_client.customerType?6:7 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)keyboardDidHide:(NSNotification *)noti {
    _tableView.frame = CGRectMake(CGRectGetMinX(_tableView.frame), CGRectGetMinY(_tableView.frame),
                                  CGRectGetWidth(_tableView.frame), CGRectGetHeight(self.view.frame)-64.0f);
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !_client.customerType ? 8 : 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_client.customerType) {
        return indexPath.row==7 ? 160.0f : 50.0f;
    }
    else {
        return indexPath.row==6 ? 160.0f : 50.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (!_client.customerType) {
        switch (indexPath.row) {
            case 0: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_name"];
                [(UITextField *)[cell viewWithTag:2] setAccessibilityIdentifier:@"tf_name"];
                [(UITextField *)[cell viewWithTag:2] setText:_dicClient[@"customerName"]];
                break;
            }
            case 1: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idType"];
                for (NSDictionary *dic in _arrTypePersonIdentify) {
                    if ([_dicClient[@"identifyType"] integerValue] == [dic[@"intKey"] integerValue]) {
                        [(UILabel *)[cell viewWithTag:1] setText:dic[@"value"]];
                    }
                }
                break;
            }
            case 2: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idNo"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_idNo"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"identifyNo"]];
                break;
            }
            case 3: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_phone"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_phone"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"phoneNo"]];
                break;
            }
            case 4: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_email"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_email"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"email"]];
                break;
            }
            case 5: {
                NSArray *arr = @[@"保密", @"男", @"女"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_gender"];
                [(UILabel *)[cell viewWithTag:1] setText:arr[[_dicClient[@"gender"] integerValue]]];
                break;
            }
            case 6: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_address"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"address"]];
                break;
            }
            case 7: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_comment"];
                [(UITextView *)[cell viewWithTag:1] setText:_dicClient[@"memo"]];
                break;
            }
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_name"];
                [(UITextField *)[cell viewWithTag:2] setAccessibilityIdentifier:@"tf_name"];
                [(UITextField *)[cell viewWithTag:2] setText:_dicClient[@"customerName"]];
                break;
            }
            case 1: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idType"];
                for (NSDictionary *dic in _arrTypeOrgIdentify) {
                    if ([_dicClient[@"identifyType"] integerValue] == [dic[@"intKey"] integerValue]) {
                        [(UILabel *)[cell viewWithTag:1] setText:dic[@"value"]];
                    }
                }
                break;
            }
            case 2: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idNo"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_idNo"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"identifyNo"]];
                break;
            }
            case 3: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_phone"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_phone"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"phoneNo"]];
                break;
            }
            case 4: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_email"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_email"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"email"]];
                break;
            }
            case 5: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
                [(UITextField *)[cell viewWithTag:1] setAccessibilityIdentifier:@"tf_address"];
                [(UITextField *)[cell viewWithTag:1] setText:_dicClient[@"address"]];
                break;
            }
            case 6: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_comment"];
                [(UITextView *)[cell viewWithTag:1] setText:_dicClient[@"memo"]];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
        if (!_client.customerType) {
            for (NSDictionary *dic in _arrTypePersonIdentify) {
                [ac addAction:[UIAlertAction actionWithTitle:dic[@"value"]
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [_dicClient setValue:dic[@"intKey"] forKey:@"identifyType"];
                                                         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                     }]];
            }
        }
        else {
            for (NSDictionary *dic in _arrTypeOrgIdentify) {
                [ac addAction:[UIAlertAction actionWithTitle:dic[@"value"]
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [_dicClient setValue:dic[@"intKey"] forKey:@"identifyType"];
                                                         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                     }]];
            }
        }
        [self presentViewController:ac animated:YES completion:nil];
    }
    else if (indexPath.row==5 && !_client.customerType) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
        [ac addAction:[UIAlertAction actionWithTitle:@"保密"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [_dicClient setValue:@(0) forKey:@"gender"];
                                                 [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                             }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"男"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [_dicClient setValue:@(1) forKey:@"gender"];
                                                 [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                             }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"女"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [_dicClient setValue:@(2) forKey:@"gender"];
                                                 [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                             }]];
        [self presentViewController:ac animated:YES completion:nil];
    }
}


#pragma mark - delegate

- (void)textViewDidChange:(UITextView *)textView {
    NSString *marked = [textView textInRange:textView.markedTextRange];
    if (!marked.length) {
        [_dicClient setValue:textView.text forKey:@"memo"];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _editingTV = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _editingTV = NO;
}


#pragma mark - action

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    [YZHttpApiManager apiClientSubmitWithParameters:_dicClient
                                  completionHandler:^(id response, NSError *error) {
                                      if ([response[@"msgCode"] integerValue] == 100) {
                                          return;
                                      }
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      _submitClientBlock();
                                  }];
}

- (IBAction)actionEditingChanged:(UITextField *)sender {
    NSString *marked = [sender textInRange:sender.markedTextRange];
    if (!marked.length) {
        if ([sender.accessibilityIdentifier isEqualToString:@"tf_name"]) {
            [_dicClient setValue:sender.text forKey:@"customerName"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_idNo"]) {
            [_dicClient setValue:sender.text forKey:@"identifyNo"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_phone"]) {
            [_dicClient setValue:sender.text forKey:@"phoneNo"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_email"]) {
            [_dicClient setValue:sender.text forKey:@"email"];
        }
        else if ([sender.accessibilityIdentifier isEqualToString:@"tf_address"]) {
            [_dicClient setValue:sender.text forKey:@"address"];
        }
    }
}

@end
