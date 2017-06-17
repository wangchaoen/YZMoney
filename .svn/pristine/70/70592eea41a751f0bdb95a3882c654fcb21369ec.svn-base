//
//  YZGuideVC.m
//  YZMoney
//
//  Created by 7仔 on 15/11/26.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZGuideVC.h"
#import "UIImage+animatedGIF.h"


@interface YZGuideVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end





@implementation YZGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    APPDELEGATE.window.userInteractionEnabled =  YES;
    _imageView.backgroundColor = [UIColor whiteColor];
//    _imageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"gif"]]];
    NSArray *arrImage = @[@"1.png", @"2.png", @"3.png"];
    self.pageControl.numberOfPages = arrImage.count;
    _scrollView.contentSize = CGSizeMake(S_W * arrImage.count, 0);
    for (NSInteger i=0; i<arrImage.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(S_W*i, 0.0f,
                                                                        S_W, S_H)];
        iv.image = [UIImage imageNamed:arrImage[i]];
        iv.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:iv];
        
        if (i == arrImage.count-1) {
            UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                     CGRectGetWidth(self.view.frame)*0.4, CGRectGetWidth(self.view.frame)*0.12)];
            b.center = CGPointMake(S_W * (arrImage.count-0.5f), S_H-120.0f);
            [b setBackgroundColor:[UIColor clearColor]];
            //            [b setTitle:@"立即体验" forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:@"experience_Image"] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
            [b addTarget:self action:@selector(actionEnterApp:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:b];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionEnterApp:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserOnline]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserShouldGet object:nil];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:nowVersion forKey:KVresion];
    APPDELEGATE.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbar_controller"];
}


#pragma mark - scroll view

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
}

@end
