//
//  YZContractView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/11.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZContractModel.h"

@protocol YZContractViewDelegate <NSObject>

- (void)clickTableCellAction;
- (void)clickButCellActionWithModel:(YZContractModel *)model;
- (void)scrollViewDidEndScroll;
@end

@interface YZContractView : UIScrollView
@property (nonatomic, assign)id<YZContractViewDelegate> viewDelegate;
- (void)searchActionWithText:(NSString *)text;
- (void)requestWithCurrentPage:(NSInteger)currentPage;
@end
