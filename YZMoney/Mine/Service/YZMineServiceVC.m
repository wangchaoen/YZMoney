//
//  YZMineServiceVC.m
//  YZMoney
//
//  Created by 7仔 on 16/1/14.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "YZMineServiceVC.h"





@interface YZMineServiceVC ()

@property (nonatomic, strong) NSDictionary *dicData;

@end





@implementation YZMineServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YZHttpApiManager apiMineServiceWithParameters:nil
                                 completionHandler:^(id response, NSError *error) {
                                     if (response) {
                                         _dicData = [response valueForKeyPath:@"data"];
                                         [self.tableView reloadData];
                                     }
                                 }];
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row ? 280.0f : 180.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_header"];
            if (ISLOGIN) {
                [(UIImageView *)[cell viewWithTag:1] setImageWithURL:[NSURL URLWithString:[url_res stringByAppendingString:_dicData[@"employeePhoto"]?:@""]] placeholderImage:[UIImage imageNamed:@"loggedin.png"]];
            }
            else {
                [(UIImageView *)[cell viewWithTag:1] setImage:[UIImage imageNamed:@"notloggedin.png"]];
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_info"];
            
            if (ISLOGIN && _dicData) {
                NSString *s = [NSString stringWithFormat:@"%@ %@", _dicData[@"employeeName"]?:@"", _dicData[@"employeePhone"]?:@""];
                NSRange range1 = [s rangeOfString:_dicData[@"employeeName"]?:@""];
                NSRange range2 = [s rangeOfString:_dicData[@"employeePhone"]?:@""];
                NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:s];
                [mas addAttribute:NSForegroundColorAttributeName value:RGBColor(159.0f, 159.0f, 159.0f, 1.0f) range:range1];
                [mas addAttribute:NSForegroundColorAttributeName value:RGBColor(255.0f, 90.0f, 90.0f, 1.0f) range:range2];

                [(UILabel *)[cell viewWithTag:1] setText:@"请联系您的专属服务经理"];
                [(UIButton *)[cell viewWithTag:2] setAttributedTitle:mas forState:UIControlStateNormal];
                [(UITextField *)[cell viewWithTag:3] setText:[_dicData valueForKeyPath:@"member.mobile"]];
                [(UILabel *)[cell viewWithTag:4] setText:_dicData[@"employeeWechatNo"]?:_dicData[@"callServiceWechatNo"]];
            }
            else {
                NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:@"400-801-9268"];
                [mas addAttribute:NSForegroundColorAttributeName value:RGBColor(255.0f, 90.0f, 90.0f, 1.0f) range:NSMakeRange(0, mas.length)];
                
                [(UILabel *)[cell viewWithTag:1] setText:@"请联系您的服务经理"];
                [(UIButton *)[cell viewWithTag:2] setAttributedTitle:mas forState:UIControlStateNormal];
                [(UITextField *)[cell viewWithTag:3] setText:[_dicData valueForKeyPath:@"member.mobile"]];
                [(UILabel *)[cell viewWithTag:4] setText:_dicData[@"callServiceWechatNo"]];
            }
            
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - action

- (IBAction)actionCall:(UIButton *)sender {
    NSString *phone = _dicData[@"employeePhone"] ? : @"400-801-9268";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}

- (IBAction)actionMobile:(UIButton *)sender {
    [YZHttpApiManager apiMineServiceSubmitWithParameters:@{@"mobile"  : [[sender.superview.superview viewWithTag:3] text],
                                                           @"productId": _idProduct?:@""}
                                       completionHandler:^(id response, NSError *error) {
                                           [YZToastView showToastWithText:@"发送成功"];
                                       }];
}

- (IBAction)actionCopy:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[sender.superview.superview viewWithTag:4] text];
    [YZToastView showToastWithText:@"成功复制到剪切板"];
}

@end
