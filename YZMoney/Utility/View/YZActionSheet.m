//
//  YZActionSheet.m
//  YZMoney
//
//  Created by 7仔 on 15/12/25.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZActionSheet.h"
#import "YZEmailView.h"
#import "YZProductModel.h"
#import "YZNewsModel.h"
#import "YZShareUtils.h"




@interface YZActionSheet ()

@property (weak, nonatomic) IBOutlet UIScrollView *svCommon;
@property (weak, nonatomic) IBOutlet UIScrollView *svShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (nonatomic, copy) NSString *idProduct;
@property (nonatomic, copy) NSString *idFavorite;

@end





@implementation YZActionSheet

- (instancetype)initWithID:(NSDictionary *)dicID arrMore:(NSArray *)arrMore arrShare:(NSArray *)arrShare {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YZActionSheet" owner:nil options:nil] objectAtIndex:0];
        self.frame = [[UIScreen mainScreen] bounds];
        [self layoutIfNeeded];
        _idProduct  = dicID[@"product"];
        _idFavorite = dicID[@"favorite"];

        NSArray *arrC = arrMore;
        if (arrC.count) {
            for (NSInteger i=0; i<arrC.count; i++) {
                UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 40.0f, 40.0f)];
                b.center = CGPointMake(CGRectGetWidth(_svCommon.frame)/8*(i*2+1), CGRectGetMidY(b.frame));
                b.tag = i;
                b.accessibilityIdentifier = arrC[i];
                [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrC[i]]] forState:UIControlStateNormal];
                [b addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_svCommon addSubview:b];
                
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(b.frame)+8.0f, 80.0f, 16.0f)];
                l.center = CGPointMake(CGRectGetWidth(_svCommon.frame)/8*(i*2+1), CGRectGetMidY(l.frame));
                l.font = [UIFont systemFontOfSize:12.0f];
                l.textColor = RGBColor(200.0f, 200.0f, 200.0f, 1.0f);
                l.textAlignment = NSTextAlignmentCenter;
                l.text = arrC[i];
                [_svCommon addSubview:l];
            }
        }
        else {
            [_svCommon removeFromSuperview];
        }
        
        NSArray *arrS = arrShare;
        if (arrS.count) {
            for (NSInteger i=0; i<arrS.count; i++) {
                UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 40.0f, 40.0f)];
                b.center = CGPointMake(CGRectGetWidth(_svShare.frame)/8*(i*2+1), CGRectGetMidY(b.frame));
                [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrS[i]]] forState:UIControlStateNormal];
                b.tag = i;
                [b addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_svShare addSubview:b];
                
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(b.frame)+8.0f, 80.0f, 16.0f)];
                l.center = CGPointMake(CGRectGetWidth(_svShare.frame)/8*(i*2+1), CGRectGetMidY(l.frame));
                l.font = [UIFont systemFontOfSize:12.0f];
                l.textColor = RGBColor(200.0f, 200.0f, 200.0f, 1.0f);
                l.textAlignment = NSTextAlignmentCenter;
                l.text = arrS[i];
                [_svShare addSubview:l];
            }
        }
        else {
            [_svShare removeFromSuperview];
        }
    }
    return self;
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    _constraintBottom.constant = 10.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = RGBColor(0.0f, 0.0f, 0.0f, 0.4f);
        [self layoutIfNeeded];
    }];
}

- (void)hide {
    _constraintBottom.constant = -170.0f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.backgroundColor = RGBColor(0.0f, 0.0f, 0.0f, 0.0f);
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches.allObjects.firstObject.view isEqual:self]) {
        [self hide];
    }
}

- (void)actionClicked:(UIButton *)sender {
    [self hide];
    if (self.black) {
        self.black(sender.tag);
    }
    switch (sender.tag) {
        case 0:
            [YZShareUtils wchatShareActionWithUrl:_shareUrl shareTitle:_shareTitle content:_shareContent image:_shareImage type:WChatShareTypeFriend];
            break;
            case 1:
            [YZShareUtils wchatShareActionWithUrl:_shareUrl shareTitle:_shareTitle content:_shareTitle image:_shareImage type:WChatShareTypeGroup];
            break;
        default:
            break;
    }
    [MobClick event:@"shareDetail" label:sender.accessibilityIdentifier];
}

@end
