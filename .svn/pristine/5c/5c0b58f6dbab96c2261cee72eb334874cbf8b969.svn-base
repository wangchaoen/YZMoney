//
//  YZMineAppointPictureVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/19.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZMineAppointPictureVC.h"





@interface YZMineAppointPictureVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) NSArray *arrKey;
@property (nonatomic, strong) NSMutableArray *arrPicture;
@property (nonatomic, assign) NSInteger indexPicture;
@property (nonatomic, assign) NSInteger countLoading;
@property (nonatomic, assign) NSInteger countDone;

@end





@implementation YZMineAppointPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!_canDone) {
        self.title = @"补传附件";
        [_button removeFromSuperview];
    }
    else {
        self.title = @"照片上传";
    }
    
    NSArray *arr = @[@"unknow", @"idCardFront", @"idCardBack", @"bankCard", @"paymentVoucher", @"contract", @"accountsPermits", @"businessLicence", @"organizationCodeCertificate", @"taxRegistrationCertificates"];
    
    if (!_type) {
        _arrKey = @[arr[1], arr[2], arr[3], arr[4]];
        _arrPicture = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"pic_001.png"], [UIImage imageNamed:@"pic_002.png"], [UIImage imageNamed:@"pic_003.png"], [UIImage imageNamed:@"pic_004.png"], nil];
    }
    else {
        _arrKey = @[arr[1], arr[2], arr[4], arr[7], arr[8], arr[9], arr[6]];
        _arrPicture = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"pic_01.png"], [UIImage imageNamed:@"pic_02.png"], [UIImage imageNamed:@"pic_03.png"], [UIImage imageNamed:@"pic_04.png"], [UIImage imageNamed:@"pic_005.png"], [UIImage imageNamed:@"pic_006.png"], [UIImage imageNamed:@"pic_007.png"], nil];
    }
    
    for (NSDictionary *dic in _arrImage) {
        NSString *key = arr[[dic[@"attachType"] integerValue]];
        if ([_arrKey indexOfObject:key] != NSNotFound) {
            [_arrPicture replaceObjectAtIndex:[_arrKey indexOfObject:key] withObject:dic];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = (CGRectGetWidth(self.view.frame)-39.0f)/2/8*5;
    return !_type ? height * 4 + 30: height * 6 + 35 * 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = !_type?4:7;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_image%ld", (long)count]];
    for (NSInteger i=1; i<count+1; i++) {
        if ([_arrPicture[i-1] isKindOfClass:[UIImage class]]) {
            [(UIImageView *)[cell.contentView viewWithTag:i] setImage:_arrPicture[i-1]];
        }
        else if ([_arrPicture[i-1] isKindOfClass:[NSDictionary class]]) {
            [(UIImageView *)[cell.contentView viewWithTag:i] setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@image/order?id=%@", url_base, [_arrPicture[i-1] valueForKey:@"id"]]] placeholderImage:nil];
        }
    }
    
    return cell;
}


#pragma mark - action

- (IBAction)actionTap:(UITapGestureRecognizer *)sender {
    _indexPicture = sender.view.tag;
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"拍照", @"从相册选取", nil];
    [as showInView:self.view];
}

- (IBAction)actionDone:(UIButton *)sender {
    if (_countLoading == _countDone) {
        [YZHttpApiManager apiOrderOrderSubmitWithParameters:@{@"id" : _idAppoint}
                                          completionHandler:^(id response, NSError *error) {
                                              _pictureDoneBlock();
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }];
    }
}


#pragma mark - delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    ip.delegate = self;
    
    switch (buttonIndex) {
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                ip.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:ip animated:YES completion:nil];
            }
            break;
        }
        case 1: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                ip.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:ip animated:YES completion:nil];
            }
            break;
        }
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *i = info[@"UIImagePickerControllerOriginalImage"];
    [_arrPicture replaceObjectAtIndex:_indexPicture-1 withObject:i];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [_tableView reloadData];
        
        _countLoading++;
        [YZHttpApiManager apiMineAppointPictureWithParameters:@{@"id"                    : _idAppoint,}
                                                         data:@{_arrKey[_indexPicture-1] : UIImageJPEGRepresentation(i, 0.2f)}
                                            completionHandler:^(id response, NSError *error) {
                                                _countDone++;
                                                _pictureDoneBlock();
                                            }];
    }];
}

@end
