//
//  YZProductDocumentVC.m
//  YZMoney
//
//  Created by weekope on 16/6/24.
//  Copyright © 2016年 yzmoney. All rights reserved.
//

#import "YZProductDocumentVC.h"
#import "WebViewController.h"




@interface YZProductDocumentVC ()

@property (nonatomic, copy) NSArray *arrDoc;

@end





@implementation YZProductDocumentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YZHttpApiManager apiProductDocumentWithParameters:@{@"productId": _idProduct}
                                     completionHandler:^(id response, NSError *error) {
                                         [YZViewManager viewManagerWithView:self.tableView
                                                                       data:[[response valueForKeyPath:@"data"] isKindOfClass:[NSArray class]]?[response valueForKeyPath:@"data"]:[NSArray array]
                                                                      error:error
                                                                      block:^{
                                                                          _arrDoc = [[response valueForKeyPath:@"data"] isKindOfClass:[NSArray class]]?[response valueForKeyPath:@"data"]:[NSArray array];
                                                                          [self.tableView reloadData];
                                                                      }];
                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrDoc.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_doc" forIndexPath:indexPath];
    [(UILabel *)[cell viewWithTag:1] setText:_arrDoc[indexPath.row][@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *url = [NSString stringWithFormat:@"%@product/readFile?productId=%@&sign=%@&isLocal=%@", url_base, _idProduct, _arrDoc[indexPath.row][@"sign"], [_arrDoc[indexPath.row][@"isLocal"] boolValue]?@"true":@"false"];
//    NSString *url = [[NSString stringWithFormat:@"%@product/readFile?productId=%@&sign=%@&isLocal=%@", url_base, _idProduct, _arrDoc[indexPath.row][@"sign"], [_arrDoc[indexPath.row][@"isLocal"] boolValue]?@"true":@"false"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

//    WebViewController *web = [[WebViewController alloc]initWithUrl: url];
//    web.navigationItem.title = _arrDoc[indexPath.row][@"name"];
//    [self.navigationController pushViewController:web animated:true];
}

@end
