//
//  HomeProductCell.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/20.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "HomeProductCell.h"
#import "YZLoginVC.h"
#import "YZProductModel.h"
#import "UIViewController+Utils.h"

@interface HomeProductCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *lblArray;
@property (nonatomic, strong) NSMutableArray *contentLblArray;
@property (nonatomic, strong) UILabel *titleLbl1;
@property (nonatomic, strong) UILabel *titleLbl2;
@property (nonatomic, strong) UILabel *titleLbl3;
@property (nonatomic, strong) UILabel *contentLbl1;
@property (nonatomic, strong) UILabel *contentLbl2;
@property (nonatomic, strong) UILabel *contentLbl3;

@property (nonatomic, strong) UILabel *noLoginLbl1;
@property (nonatomic, strong) UILabel *noLoginLbl2;
@property (nonatomic, strong) UILabel *noLoginLbl3;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CAGradientLayer *lineLayer;

@property (nonatomic, strong) UIImageView *newImage;
@end

@implementation HomeProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = YZ_GRAY_COLOR;
        
        self.array = [NSMutableArray array];
        self.lblArray = [NSMutableArray array];
        self.contentLblArray = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor whiteColor];
//        self.backView.layer.cornerRadius = 2;
//        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        [self creatView];
        
    }
    return self;
}
- (void)creatView {
    [self.backView addSubview:self.titleImage];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.typeLbl];
    [self.backView addSubview:self.footLbl];
    [self.backView addSubview:self.newImage];
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.lineView.frame;
    gradientLayer.colors =  @[(id)[UIColor clearColor].CGColor,(id)RGBColor(244, 244, 244, 1).CGColor, (id)[UIColor clearColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 2);
    gradientLayer.endPoint = CGPointMake(2, 2);
    
    [_backView.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = self.lineView.layer;
    self.lineLayer = gradientLayer;
}
- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
    }
    return _titleImage;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = BigFont;
    }
    return _titleLbl;
}
- (UILabel *)typeLbl {
    if (!_typeLbl) {
        _typeLbl = [[UILabel alloc]init];
        _typeLbl.textColor = [UIColor whiteColor];
        _typeLbl.font = MinFont;
        _typeLbl.text = @"在售";
        _typeLbl.textAlignment = NSTextAlignmentCenter;
        _typeLbl.backgroundColor = RGBColor(252, 139, 114, 1);
    }
    return _typeLbl;
}
- (UILabel *)footLbl {
    if (!_footLbl) {
        _footLbl = [[UILabel alloc]init];
        _footLbl.numberOfLines = 0;
        _footLbl.font = [UIFont systemFontOfSize:12];
        _footLbl.textColor = [UIColor lightGrayColor];
    }
    return _footLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc]init];
        lineView.alpha = .5;
        _lineView = lineView;
    }
    return _lineView;
}
- (UIImageView *)newImage {
    if (!_newImage) {
        _newImage = [[UIImageView alloc]initWithFrame:CGRectMake(S_W - 10 - 30, 0, 30, 30)];
        _newImage.image = [UIImage imageNamed:@"new_icon"];
        _newImage.hidden = YES;
    }
    return _newImage;
}
#pragma mark - creatView
- (void)createLblActionWithArray:(NSArray *)array {
    for (UIView *view in self.array) {
        [view removeFromSuperview];
    }
    CGFloat upInterval = 5;
    CGFloat BF = CGRectGetMaxX(self.titleImage.frame) + 10;
    CGFloat interval = 5;
    NSInteger rows = 0;
    CGFloat beforeWith = BF;
    CGFloat width = S_W - 10;
    for (int i = 0; i < array.count; i++) {
        UILabel *but = [UILabel new];
    
        but.font = [UIFont systemFontOfSize:14];
        but.tag = i;
        but.layer.cornerRadius = 4;
        but.layer.masksToBounds = true;
        but.layer.borderColor = [UIColor lightGrayColor].CGColor;
        but.layer.borderWidth = 1;
        but.textColor = [UIColor lightGrayColor];
        but.text = array[i];
        but.textAlignment = NSTextAlignmentCenter;
        [self.array addObject:but];
        CGSize timeSize = [Utility calculatelblSizeForFont:14 scope:CGSizeMake(MAXFLOAT, 20) text:array[i]];
                    timeSize.width += 5;
        if (timeSize.width > width - 50) {
            timeSize.width = width - 70;
        }
        if ((width - beforeWith < timeSize.width) && (beforeWith != BF)) {
            rows += 1;
            beforeWith = BF;
        }
        but.frame = CGRectMake(beforeWith, upInterval + CGRectGetMaxY(self.titleLbl.frame) + 10 + rows * (25 + upInterval), timeSize.width + 5, 25);
        
        beforeWith = beforeWith + but.frame.size.width + interval;
        [self.contentView addSubview:but];
    }
}
- (void)createLblWithheight:(CGFloat)height{
    for (UIView *view in self.lblArray) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.contentLblArray) {
        [view removeFromSuperview];
    }
    CGFloat width = S_W - 20;
    for (int i = 0; i < 3; i++) {
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(width / 3 * i + 20, height, width / 3, 20)];
        titleLbl.userInteractionEnabled = YES;
        if (i == 0) {
            titleLbl.textColor = YZ_RED_COLOR;
            titleLbl.font = [UIFont systemFontOfSize:16];
        }else {
            titleLbl.font = [UIFont systemFontOfSize:14];
        }
        titleLbl.text = @"--";
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:titleLbl];
        
        UILabel *contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(i * width / 3 + 20, CGRectGetMaxY(titleLbl.frame) + 5, width / 3, 15)];
        contentLbl.font = [UIFont systemFontOfSize:14];
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:contentLbl];
        
        UILabel *loginLbl =[[UILabel alloc]init];
        loginLbl.frame = CGRectMake((contentLbl.frame.size.width - 70) / 2, -4, 70, 23);
        loginLbl.text = @"登录可见";
        loginLbl.backgroundColor = YZ_RED_COLOR;
        loginLbl.textColor = [UIColor whiteColor];
        loginLbl.font = [UIFont systemFontOfSize:14];
        loginLbl.hidden = YES;
        loginLbl.layer.cornerRadius = 4;
        loginLbl.layer.masksToBounds = YES;
        loginLbl.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction)];
        loginLbl.userInteractionEnabled = YES;
        [loginLbl addGestureRecognizer:tap];
        [titleLbl addSubview:loginLbl];
        
        if (i == 0){
            self.titleLbl1 = titleLbl;
            self.contentLbl1 = contentLbl;
            self.noLoginLbl1 = loginLbl;
            contentLbl.text = @"预期收益";
        }else if (i == 1) {
            self.titleLbl2 = titleLbl;
            self.contentLbl2 = contentLbl;
            self.noLoginLbl2 = loginLbl;
            contentLbl.text = @"投资期限";
        }else{
            contentLbl.text = @"返佣率";
            self.titleLbl3 = titleLbl;
            self.titleLbl3.textColor = YZ_RED_COLOR;
            self.noLoginLbl3 = loginLbl;
            self.contentLbl3 = contentLbl;
        }
        [self.lblArray addObject:titleLbl];
        [self.contentLblArray addObject:contentLbl];
    }
}
- (void)calculateTitleLblFrame {
    CGSize typeSize = [Utility calculatelblSizeForFont:12 scope:CGSizeMake(80, 15) text: self.typeLbl.text];
//    if ([self.titleLbl.text isEqualToString:@"兴晟资产-债券2号slnfsdlfngvlsdfngbldnfblkdfbkldkfdfvb（null期）"]) {
//        NSLog(@"1");
//    }
    CGSize size = [Utility calculatelblSizeForFont:16 scope:CGSizeMake(S_W - 90, 20) text:self.titleLbl.text];
    self.titleLbl.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame) + 5, 20, size.width, 20);
    self.typeLbl.frame = CGRectMake(CGRectGetMaxX(self.titleLbl.frame) + 5, CGRectGetMinY(self.titleLbl.frame) + 2.5, typeSize.width + 5, 15);
}

+ (CGFloat) calculateRowsHeight:(NSArray *)array {
    CGFloat upInterval = 5;
    CGFloat BF = 50;
    CGFloat interval = 5;
    NSInteger rows = 0;
    CGFloat beforeWith = BF;
    CGFloat width = S_W - 10;
    for (NSString *str in array) {
        CGSize timeSize = [Utility calculatelblSizeForFont:14 scope:CGSizeMake(MAXFLOAT, 20) text:str];
        timeSize.width += 5;
        if (timeSize.width > width - 50) {
            timeSize.width = width - 70;
        }
        if ((width - beforeWith < timeSize.width) && (beforeWith != BF)) {
            rows += 1;
            beforeWith = BF;
        }
        
        beforeWith = beforeWith + timeSize.width + 5 + interval;
    }
    return 10 + (rows + 1) * (25 + upInterval);
}
#pragma mark - action 
- (void)loginAction {
    [Utility goLogin];
}
#pragma mark - GetRowsHeight
+ (CGFloat)returnRowsHeightWith:(YZProductModel *)model {
    CGFloat lblHeight = [HomeProductCell calculateRowsHeight: model.tagList];
    
    CGSize size = [Utility calculatelblSizeForFont:12 scope:CGSizeMake(S_W - 20, MAXFLOAT) text:model.progressDesc];
    CGFloat height = lblHeight + 30 + 40 + 30 + size.height + 10 + 10 + 10 + 10;
    return height;
}

#pragma mark - Assignment
- (void)sendModelViewIndexWith:(YZProductModel *)model {
    self.titleLbl.text = model.title;
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_res, model.priorPreviewImgUrl]] placeholderImage:nil];
    self.typeLbl.text = model.saleStatusView;
    if (model.soldOut) {
        self.typeLbl.text = @"售罄";
    }
    if (!model.onMarketing) {
        self.typeLbl.text = @"失效";
    }
    self.newImage.hidden = model.newProduct ? NO : YES;
    //    //计算titleFrame
    [self calculateTitleLblFrame];
    //    //创建标签
    [self createLblActionWithArray: model.tagList];
    //获得标签高度
        CGFloat height = [HomeProductCell calculateRowsHeight: model.tagList];
        height = height + 5 + CGRectGetMaxY(self.titleImage.frame);
    //    // 创建下行lbl
        [self createLblWithheight:height];
    CGSize size = [Utility calculatelblSizeForFont:12 scope:CGSizeMake(S_W - 20, MAXFLOAT) text:model.progressDesc];
    self.footLbl.text = model.progressDesc;
    self.footLbl.frame = CGRectMake(10, height + 60, S_W - 20, size.height + 10);
    self.backView.frame = CGRectMake(5, 5, S_W - 10, CGRectGetMaxY(self.footLbl.frame) + 10);
    self.lineView.frame = CGRectMake(40, height + 50, CGRectGetWidth(self.backView.frame) - 40 * 2, 1);
    self.lineLayer.frame = self.lineView.frame;
    [self.backView addSubview:self.lineView];

    for (int i = 0; i < model.gridViewList.count; i++) {
        NSDictionary *dic = model.gridViewList[i];
        BOOL checkLogin = [dic[@"checkLogin"] boolValue];
        if (i == 0) {
            self.contentLbl1.text = dic[@"name"];
            self.titleLbl1.text = dic[@"value"];
            if (checkLogin && !ISLOGIN) {
                self.noLoginLbl1.hidden = NO;
            }else{
                self.noLoginLbl1.hidden = YES;
            }
        }else if (i == 1){
            self.contentLbl2.text = dic[@"name"];
            self.titleLbl2.text = dic[@"value"];
            if (checkLogin && !ISLOGIN) {
                self.noLoginLbl2.hidden = NO;
            }else{
                self.noLoginLbl2.hidden = YES;
            }
        }else{
            self.contentLbl3.text = dic[@"name"];
            self.titleLbl3.text = dic[@"value"];
            if (checkLogin && !ISLOGIN) {
                self.noLoginLbl3.hidden = NO;
            }else{
                self.noLoginLbl3.hidden = YES;
            }
        }
    }
}
@end