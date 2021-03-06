//
//  YZApplyVC.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/25.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZApplyVC.h"
#import "YZApplyCell.h"
#import "YZAddressVC.h"
#import "YZAddNumberView.h"
#import "YZAddressModel.h"

@interface YZApplyVC ()<UITableViewDataSource, UITableViewDelegate, YZAddressVCDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YZAddNumberView *addNumberView;
@property (nonatomic, strong) YZAddressModel *addressModel;
@end

@implementation YZApplyVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOT_USEADDRESS_APPLY object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addressResquest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAddressNot:) name:NOT_USEADDRESS_APPLY object:nil];
    self.navigationItem.title = @"申请";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = YZ_GRAY_COLOR;
    
    UIButton *submitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBut.backgroundColor = YZ_RED_COLOR;
    submitBut.frame = CGRectMake(30, S_H - 50, S_W - 60, 40);
    [submitBut setTitle:@"提交申请" forState:UIControlStateNormal];
    [submitBut addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    submitBut.titleLabel.font = MidFont;
    submitBut.layer.cornerRadius = 4;
    submitBut.layer.masksToBounds = YES;
    [submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBut];
}
- (void)addressResquest {
    WEAK_SELF;
    [YZHttpApiManager apiMineContractGetDefaultAddressWithParameters:nil completionHandler:^(id response, NSError *error) {
        
        if (response) {
            weakSelf.addressModel = nil;
                YZAddressModel *model = [[YZAddressModel alloc]initWithDict:[response valueForKeyPath:@"data.addressData"]];
                NSLog(@"%@", model.receivePhone);
                weakSelf.addressModel = model;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, S_W - 10, S_H - 5 - 50)];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[YZApplyCell class] forCellReuseIdentifier:NSStringFromClass([YZApplyCell class])];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YZApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZApplyCell class])];
        [cell sendModelWithModel:self.addressModel];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = MidFont;
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, S_W, 1)];
        lineView.backgroundColor = YZ_GRAY_COLOR;
        [cell.contentView addSubview:lineView];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"产品名称";
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(S_W - 180 - 20, 0, 180, 50)];
            lbl.font = MidFont;
            lbl.textAlignment = NSTextAlignmentRight;
//            lbl.text = @"中江信托-金虎318号 3期";
            lbl.text = self.contractMD.name;
            [cell.contentView addSubview:lbl];
        }else {
            cell.textLabel.text = @"申请数量";
            if (!self.addNumberView) {
                self.addNumberView = [[YZAddNumberView alloc]initWithFrame:CGRectMake(S_W - 130, 10, 110, 30)];
                [cell.contentView addSubview:self.addNumberView];
            }
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 65;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YZAddressVC *vc = [[YZAddressVC alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - not 
- (void)sendAddressNot:(NSNotification *)not {
    YZAddressModel *model = not.userInfo[@"addressModel"];
    self.addressModel = model;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - customDelegate
- (void)deleteBackWithModel:(YZAddressModel *)model {
    if ([self.addressModel.ID isEqualToString:model.ID]) {
//        if (model.isDefault) {
//            self.addressModel = nil;
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
            [self addressResquest];
//        }
    }
}
#pragma mark - action
- (void)submitAction {
    if (!self.addressModel) {
        [YZToastView showToastWithText:@"请添加您的地址"];
        return;
    }
    WEAK_SELF;
    [YZHttpApiManager apiMineSubmitContractWithParameters:@{@"id": self.contractMD.ID, @"addressId": self.addressModel.ID, @"applyCount": self.addNumberView.textField.text} completionHandler:^(id response, NSError *error) {
        if ([response[@"code"] integerValue] == 0) {
            [YZToastView showToastWithText:@"申请成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(applySuccessClick)]) {
                [weakSelf.delegate applySuccessClick];
            }
        }
    }];
//
}
@end
