//
//  YZClientViewVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/23.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZClientViewVC.h"
#import "YZClientEditVC.h"





@interface YZClientViewVC ()

@end





@implementation YZClientViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !_client.customerType ? 9 : 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_client.customerType) {
        return indexPath.row==8 ? 160.0f : 50.0f;
    }
    else {
        return indexPath.row==7 ? 160.0f : 50.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (!_client.customerType) {
        switch (indexPath.row) {
            case 0: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_type"];
                [(UILabel *)[cell viewWithTag:1] setText:@"自然人"];
                break;
            }
            case 1: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_name"];
                [(UILabel *)[cell viewWithTag:2] setText:_client.customerName];
                break;
            }
            case 2: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idType"];
                for (NSDictionary *dic in _arrTypePersonIdentify) {
                    if (_client.identifyType == [dic[@"intKey"] integerValue]) {
                        [(UILabel *)[cell viewWithTag:1] setText:dic[@"value"]];
                    }
                }
                break;
            }
            case 3: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idNo"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.identifyNo];
                break;
            }
            case 4: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_phone"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.phoneNo];
                break;
            }
            case 5: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_email"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.identifyNo];
                break;
            }
            case 6: {
                NSArray *arr = @[@"保密", @"男", @"女"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_gender"];
                [(UILabel *)[cell viewWithTag:1] setText:arr[_client.gender]];
                break;
            }
            case 7: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.address];
                break;
            }
            case 8: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_comment"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.memo];
                break;
            }
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_type"];
                [(UILabel *)[cell viewWithTag:1] setText:@"机构"];
                break;
            }
            case 1: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_name"];
                [(UILabel *)[cell viewWithTag:2] setText:_client.customerName];
                break;
            }
            case 2: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idType"];
                for (NSDictionary *dic in _arrTypeOrgIdentify) {
                    if (_client.identifyType == [dic[@"intKey"] integerValue]) {
                        [(UILabel *)[cell viewWithTag:1] setText:dic[@"value"]];
                    }
                }
                break;
            }
            case 3: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idNo"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.identifyNo];
                break;
            }
            case 4: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_phone"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.phoneNo];
                break;
            }
            case 5: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_email"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.email];
                break;
            }
            case 6: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.address];
                break;
            }
            case 7: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_comment"];
                [(UILabel *)[cell viewWithTag:1] setText:_client.memo];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_client_edit"]) {
        [(YZClientEditVC *)segue.destinationViewController setClient:_client];
        [(YZClientEditVC *)segue.destinationViewController setSubmitClientBlock:^{
            [YZHttpApiManager apiClientDetailWithParameters:@{@"id": _client.ID}
                                          completionHandler:^(id response, NSError *error) {
                                              _client = (YZClientModel *)[[[YZClientModel alloc] init] modelFromJson:[response valueForKeyPath:@"data.customerData"]];
                                              [self.tableView reloadData];
                                          }];
            _submitClientBlock();
        }];
        [(YZClientEditVC *)segue.destinationViewController setArrTypePersonIdentify:_arrTypePersonIdentify];
        [(YZClientEditVC *)segue.destinationViewController setArrTypeOrgIdentify:_arrTypeOrgIdentify];
    }
}

@end
