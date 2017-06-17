//
//  YZImageSV.h
//  YZMoney
//
//  Created by 7仔 on 15/12/1.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface YZImageSV : UIScrollView

- (id)initWithFrame:(CGRect)frame images:(NSArray *)arrImage page:(NSInteger)page;
- (void)showImageSV;

@end
