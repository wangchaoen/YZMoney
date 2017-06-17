//
//  YZADScrollView.m
//  YZMoney
//
//  Created by 7仔 on 15/11/6.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZADScrollView.h"
#import "YZADModel.h"
#import "YZHttpClient.h"
#import "YZProductDetailVC.h"
#import <SDCycleScrollView/SDCycleScrollView.h>



@interface YZADScrollView () <UIScrollViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrImage;
@property (nonatomic, assign) UIViewController *vc;
@property (nonatomic, strong) NSArray *arrAD;
@end





@implementation YZADScrollView

-(void)createScrollViewWithArray:(NSArray *)array vc:(UIViewController *)vc {
    self.arrAD = array;
    self.vc = vc;
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:[UIImage imageNamed:@"750-360占位图.png"]];
    scrollView.autoScrollTimeInterval = 5;
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.showPageControl = YES;
    scrollView.imageURLStringsGroup = self.arrImage;
    [self addSubview:scrollView];
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YZADModel *model = _arrAD[index];
    if ([model.url containsString:@"linkType=product"]) {
        [self.vc performSegueWithIdentifier:@"segue_ad_product" sender:model.url];
    }else if ([model.url containsString:@"linkType=article"]) {
        [_vc performSegueWithIdentifier:@"segue_ad_news" sender: model.url];
    } else {
        YZProductDetailVC *productVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc_product"];
        productVC.url = model.url;
        productVC.projectVC = YES;
        productVC.model = model;
        [self.vc.navigationController pushViewController:productVC animated:YES];
    }
    
    [MobClick event:@"index_banner" label:[_arrAD[index] ID]];
}

- (void)setArrAD:(NSArray *)arrAD {
    _arrAD = arrAD;
    _arrImage = [NSMutableArray array];
    for (YZADModel *ad in _arrAD) {
        [_arrImage addObject:ad.image];
    }
}
@end