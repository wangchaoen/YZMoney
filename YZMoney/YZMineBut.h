//
//  YZMineBut.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/6.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZMineBut : UIButton
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *lbl;
//@property (nonatomic, strong) UILabel *loginLbl;
- (void)createView;
- (void)loginWithArray:(NSArray *)array index:(NSInteger)index;
@end
