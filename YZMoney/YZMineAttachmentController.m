//
//  YZMineAttachmentController.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/1.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZMineAttachmentController.h"
#import "AddImageCell.h"
#import "IDCardCell.h"
#import "YZLoadImModel.h"

@interface YZMineAttachmentController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IDCardCellDelegate, AddImageCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBut;

@property (nonatomic, assign) BackType backType;
// 身份证（法人身份证）
@property (nonatomic, strong) NSMutableArray *IDCardArr;

// 银行卡
@property (nonatomic, strong) NSMutableArray *bankCardArr;

// 打款凭证
@property (nonatomic, strong) NSMutableArray *paymentVoucherArr;

// 机构证件
@property (nonatomic, strong) NSMutableArray *organizationCodeCertificateArr;

// 法人证明
@property (nonatomic, strong) NSMutableArray *LegalPerArr;

// 开户行许可
@property (nonatomic, strong) NSMutableArray *bankTureArr;

@property (nonatomic, copy) NSArray *keyArr;
@end

@implementation YZMineAttachmentController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOT_REFESH_MINEAPPDEAIL object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageInitWithArray:self.imageArr];
    self.keyArr = @[@"unknow", // 未知
                     @"idCardFront", //身份证正面
                     @"idCardBack", // 身份证反面
                     @"bankCard", // 银行卡
                     @"paymentVoucher",// 打款凭证
                     @"contract", // 合同
                     @"accountsPermits", // 开户行许可
                     @"businessLicence", // 营业执照
                     @"organizationCodeCertificate", // 组织机构代码
                     @"taxRegistrationCertificates", // 税务登记
                     @"orgLicence", // 三证合一
                     @"corporateCertificate" // 法人证明书
                     ];

    [self.view addSubview:self.tableView];
    self.backType = UnKnow;
    self.navigationItem.title = @"订单详情";
    
    if (self.isSupplement) {
        self.tableView.frame = CGRectMake(0, 0, S_W, S_H - 40);
        [self.view addSubview:self.submitBut];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[IDCardCell class] forCellReuseIdentifier:NSStringFromClass([IDCardCell class])];
        [_tableView registerClass:[AddImageCell class] forCellReuseIdentifier:NSStringFromClass([AddImageCell class])];
    }
    return _tableView;
}
- (UIButton *)submitBut {
    if (!_submitBut) {
        _submitBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBut.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), S_W, 40);
        [_submitBut setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBut setBgColorNormal:YZ_RED_COLOR];
        _submitBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitBut addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBut;
}
#pragma mark - utils
- (void)imageInitWithArray:(NSArray *)array {
    self.IDCardArr = [NSMutableArray array];
    self.bankCardArr = [NSMutableArray array];
    self.paymentVoucherArr = [NSMutableArray array];
    self.organizationCodeCertificateArr = [NSMutableArray array];
    self.LegalPerArr = [NSMutableArray array];
    self.bankTureArr = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        YZLoadImModel *model = [[YZLoadImModel alloc]init];
        [model modelFromJson:dic];
        switch (model.attachType) {
            case 1:
                [self.IDCardArr addObject:model];
                break;
            case 2:
                [self.IDCardArr addObject:model];
                break;
            case 3:
                [self.bankCardArr addObject:model];
                break;
            case 4:
                [self.paymentVoucherArr addObject:model];
                break;
            case 6:
                [self.bankTureArr addObject:model];
                break;
            case 8:
                [self.organizationCodeCertificateArr addObject:model];
                break;
            case 11:
                [self.LegalPerArr addObject:model];
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }
}
#pragma mark - 提交
- (void)submitAction {
//    bankCardArr
//    paymentVoucherArr
//    businessLicenceArr
//    LegalPerArr
//    bankTureArr
    if (self.IDCardArr.count > 0 || self.bankCardArr.count > 0 || self.paymentVoucherArr > 0 || self.organizationCodeCertificateArr.count || self.LegalPerArr.count > 0 || self.bankCardArr.count > 0) {
        [YZHttpApiManager apiOrderOrderSubmitWithParameters:@{@"id" : _idAppoint, @"message": @""}
                                          completionHandler:^(id response, NSError *error) {
//                                              _pictureDoneBlock();
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }];
    } else{
        NSLog(@"没有添加图片");
        return;
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.showType == ShowTypeFirst ? 3 : 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IDCardCell class])];
        if (self.showType == ShowTypeSecond) {
            cell.positiveLbl.text = @"法人身份证正面";
            cell.backLbl.text = @"法人身份证反面";
        }else {
            cell.positiveLbl.text = @"身份证正面";
            cell.backLbl.text = @"身份证反面";
        }
            cell.positiveImage.image = [UIImage imageNamed:@"AddCardImage.png"];
            cell.backImage.image = [UIImage imageNamed:@"AddCardImage.png"];
        cell.delegate = self;
        
        for (YZLoadImModel *model in self.IDCardArr) {
            if (model.attachType == 1) {
                NSString *url = [NSString stringWithFormat:@"%@%@", url_base, model.url];
                [cell.positiveImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            }else if (model.attachType == 2){
                NSString *url = [NSString stringWithFormat:@"%@%@", url_base, model.url];
                [cell.backImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            }
        }

        return cell;
    }else {
        AddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddImageCell class])];
        cell.showAddImage = true;
        cell.delegate = self;
        switch (indexPath.row) {
            case 1:{
                if (self.showType == ShowTypeSecond) {
                    cell.titleLbl.text = @"机构证件";
                    [cell sendArrayCreatViewIndex:indexPath imageArr:self.organizationCodeCertificateArr];
                } else {
                    cell.titleLbl.text = @"银行卡";
                    [cell sendArrayCreatViewIndex:indexPath imageArr:self.bankCardArr];
                }
            }
                break;
            case 2:{
                if (self.showType == ShowTypeSecond) {
                    cell.titleLbl.text = @"法人证明书";
                    [cell sendArrayCreatViewIndex:indexPath imageArr:self.LegalPerArr];
                }else {
                    cell.titleLbl.text = @"打款凭证";
                    [cell sendArrayCreatViewIndex:indexPath imageArr:self.paymentVoucherArr];
                }
                break;
            }
            case 3:{
                cell.titleLbl.text = @"开户许可";
                [cell sendArrayCreatViewIndex:indexPath imageArr:self.bankTureArr];
            }
                break;
            case 4:{
                cell.titleLbl.text = @"打款凭证";
                [cell sendArrayCreatViewIndex:indexPath imageArr:self.paymentVoucherArr];
            }
                break;
            default:
                break;
        }
        cell.lastImage.image = [UIImage imageNamed:@"AddCardImage.png"];
        return  cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger a = 1;
    switch (indexPath.row) {
        case 1:{
            if (self.showType == ShowTypeSecond) {
                a += self.organizationCodeCertificateArr.count;
            }else {
                a += self.bankCardArr.count;
            }
        }
            break;
        case 2:{
            if (self.showType == ShowTypeSecond) {
                a += self.LegalPerArr.count;
            }else {
                a += self.paymentVoucherArr.count;
            }
        }
            break;
            case 3:
            a += self.bankTureArr.count;
            break;
            case 4:
            a += self.paymentVoucherArr.count;
            break;
        default:
            break;
    }
    CGFloat height = 110;

    if (indexPath.row == 0) {
        return height + 50;
    }
    return 50 + height * ((a + 1) / 2) + 20 * ((a + 1) / 2);
}
#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    UIImage *im = image;
    [picker dismissViewControllerAnimated:true completion:nil];
    NSString *name = @"";
    switch (self.backType) {
        case idCardFront:
            name = self.keyArr[1];
            break;
        case idCardBack:
            name = self.keyArr[2];
            break;
        case bankCard:
            name = self.keyArr[3];
            break;
        case paymentVoucher:
            name = self.keyArr[4];
            break;
        case accountsPermits:
            name = self.keyArr[6];
            break;
        case organizationCodeCertificate:
            name = self.keyArr[8];
            break;
        case corporateCertificate:
            name = self.keyArr[self.keyArr.count - 1];
            break;
        default:
            break;
    }
    WEAK_SELF;
    NSData *data = UIImageJPEGRepresentation(im, 0.2f);
    [YZHttpApiManager apiMineAppointPictureWithParameters:@{@"id": self.idAppoint} data:@{name: data} completionHandler:^(id response, NSError *error) {
        if (response) {
            NSDictionary *data = response[@"data"];
            NSDictionary *orderData = data[@"orderData"];
            NSArray *array = orderData[@"fileViewList"];
            [weakSelf imageInitWithArray:array];
        }
    }];
}
#pragma mark - customDelegate
- (void)touchIDCardCellDelegateAction:(UIView *)view {
    BOOL judge = false;
    if (view.tag == 0) {
        for (YZLoadImModel *model in self.IDCardArr) {
            if (model.attachType == 1) {
                judge = true;
            }
        }
        if (!judge) {
            [self publicAddImageActionType:idCardFront];
        }
    }else {
        for (YZLoadImModel *model in self.IDCardArr) {
            if (model.attachType == 2) {
                judge = true;
            }
        }
        if (!judge) {
            [self publicAddImageActionType:idCardBack];
        }
    }

}
- (void)addImageDelegateImage:(UIView *)view index:(NSIndexPath *)index {
    BackType type = UnKnow;
    switch (index.row) {
        case 1:{
            if (self.showType == ShowTypeFirst) {
                type = bankCard;
            }else {
                type = organizationCodeCertificate;
            }
        }
            break;
        case 2:{
            if (self.showType == ShowTypeFirst) {
                type = paymentVoucher;
            }else {
                type = corporateCertificate;
            }
        }
            break;

            case 3:
            type = accountsPermits;
            break;
            
            case 4:
            type = paymentVoucher;
            break;
            
        default:
            break;
    }
    [self publicAddImageActionType: type];
}
- (void)publicAddImageActionType:(BackType)type {
    self.backType = type;
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    ip.delegate = self;
    ip.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ip animated:YES completion:nil];
}
#pragma mark - delete
- (void)IDCardLongtap:(UIView *)view {
    WEAK_SELF;
    if (view.tag == 0) {
        for (YZLoadImModel *model in self.IDCardArr) {
            if (model.attachType == 1) {
                [self publicDeleteActionId:model.ID finish:^{
                    [weakSelf.IDCardArr removeObject:model];
                    [weakSelf.tableView reloadData];
                    return;
                }];
            }
        }
    }else {
        for (YZLoadImModel *model in self.IDCardArr) {
            if (model.attachType == 2) {
                [self publicDeleteActionId:model.ID finish:^{
                    [weakSelf.IDCardArr removeObject:model];
                    [weakSelf.tableView reloadData];
                    return;
                }];
            }
        }
    }
}

- (void)addImageLongTap:(UIView *)view index:(NSIndexPath *)index {
    WEAK_SELF;
    NSString *fileId = @"";
    switch (index.row) {
        case 1:{
            if (self.showType == ShowTypeFirst) {
                YZLoadImModel *model = self.bankCardArr[view.tag];
                fileId = model.ID;
                [self publicDeleteActionId:fileId finish:^{
                    [weakSelf.bankCardArr removeObjectAtIndex:view.tag];
                    [weakSelf.tableView reloadData];
                }];
            }else {
                YZLoadImModel *model = self.organizationCodeCertificateArr[view.tag];
                fileId = model.ID;
                [self publicDeleteActionId:fileId finish:^{
                    [weakSelf.organizationCodeCertificateArr removeObjectAtIndex:view.tag];
                    [weakSelf.tableView reloadData];
                }];
            }
        }
            break;
        case 2:{
            if (self.showType == ShowTypeFirst) {
                YZLoadImModel *model = self.paymentVoucherArr[view.tag];
                fileId = model.ID;
                [self publicDeleteActionId:fileId finish:^{
                    [weakSelf.paymentVoucherArr removeObjectAtIndex:view.tag];
                    [weakSelf.tableView reloadData];
                }];
            }else {
                YZLoadImModel *model = self.LegalPerArr[view.tag];
                fileId = model.ID;
                [self publicDeleteActionId:fileId finish:^{
                    [weakSelf.LegalPerArr removeObjectAtIndex:view.tag];
                    [weakSelf.tableView reloadData];
                }];
            }
        }
            break;
            
        case 3:{
            YZLoadImModel *model = self.bankTureArr[view.tag];
            fileId = model.ID;
            [self publicDeleteActionId:fileId finish:^{
                [weakSelf.bankTureArr removeObjectAtIndex:view.tag];
                [weakSelf.tableView reloadData];

            }];
        }
            break;
            
        case 4:{
            YZLoadImModel *model = self.paymentVoucherArr[view.tag];
            fileId = model.ID;
            [self publicDeleteActionId:fileId finish:^{
                [weakSelf.paymentVoucherArr removeObjectAtIndex:view.tag];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
   
    //orderdeletepic
}
- (void)publicDeleteActionId:(NSString *)fileId finish:(void(^)())block{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消"
                                           style:UIAlertActionStyleCancel
                                         handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"删除照片"                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             [YZHttpApiManager apiMineAppointImageDeleteWithParameters:@{@"id": self.idAppoint, @"fileId": fileId} completionHandler:^(id response, NSError *error) {
                                                 if (response) {
                                                     block();
                                                 }
                                             }];
                                         }]];
    [self presentViewController:ac animated:YES completion:nil];
}
@end
