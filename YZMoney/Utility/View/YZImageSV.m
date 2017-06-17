//
//  YZImageSV.m
//  YZMoney
//
//  Created by 7仔 on 15/12/1.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZImageSV.h"





@interface YZImageSV () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *arrImage;
@property (nonatomic, strong) UILabel *lPage;
@property (nonatomic, assign) NSInteger page;

@end





@implementation YZImageSV

- (id)initWithFrame:(CGRect)frame images:(NSArray *)arrImage page:(NSInteger)page {
    self = [super initWithFrame:frame];
    if (self) {
        _page = page;
        _arrImage = arrImage;
        self.contentSize = CGSizeMake(CGRectGetWidth(frame)*_arrImage.count, CGRectGetHeight(frame));
        self.contentOffset = CGPointMake(CGRectGetWidth(frame)*_page, 0.0f);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        UIVisualEffectView *vev = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(frame), 0.0f,
                                                                                       CGRectGetWidth(frame)*(_arrImage.count+2), CGRectGetHeight(frame))];
        vev.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        [self insertSubview:vev belowSubview:self];

        for (NSInteger i=0; i<_arrImage.count; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)*i, 0.0f,
                                                                            CGRectGetWidth(frame), CGRectGetHeight(frame))];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [iv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@image/order?id=%@", url_base, [_arrImage[i] valueForKey:@"id"]]] placeholderImage:nil];
            iv.userInteractionEnabled = YES;
            [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
            [self addSubview:iv];
        }
    }
    return self;
}

- (void)showImageSV {
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    _lPage = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.frame)-60.0f, CGRectGetWidth(self.frame), 40.0f)];
    _lPage.text = [NSString stringWithFormat:@"%ld/%lu", (long)_page+1, (unsigned long)_arrImage.count];
    _lPage.textAlignment = NSTextAlignmentCenter;
    _lPage.textColor = [UIColor whiteColor];
    [window addSubview:_lPage];
}

- (void)actionTap:(UITapGestureRecognizer *)gesture {
    [_lPage removeFromSuperview];
    [self removeFromSuperview];
}


#pragma mark - delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _page = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    _lPage.text = [NSString stringWithFormat:@"%ld/%lu", (long)_page+1, (unsigned long)_arrImage.count];
}

@end
