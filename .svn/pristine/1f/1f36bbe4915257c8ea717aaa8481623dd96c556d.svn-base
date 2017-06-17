//
//  SearchTtitleView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/10.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTitleViewDelegate <NSObject>

- (void)searchTitleViewAction;

@end
@interface SearchTitleView : UIView
@property (nonatomic, strong) UILabel *titlelbl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) id<SearchTitleViewDelegate> delegate;
- (void)changeTopColor;
- (void)changeUpColor;

@end
