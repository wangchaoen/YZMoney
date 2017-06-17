//
//  SearchHisView.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/13.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchHisModel;

typedef NS_ENUM(NSInteger, ComeTypeWithSearch){
    ComeTypeWithSearchIndex = 0,
    ComeTypeWithSearchNews,
    ComeTypeWithSearchOrder,
    ComeTypeWithSearchCibbtract
};

@protocol SearchHisViewDelegate <NSObject>

- (void)historySearchAction:(SearchHisModel *)text isLabel:(BOOL)isLabel;

@end

@interface SearchHisView : UIView

@property (nonatomic, assign) id<SearchHisViewDelegate> delegate;
@property (nonatomic, assign) ComeTypeWithSearch comeType;

- (instancetype)initWithFrame:(CGRect)frame withComeType:(ComeTypeWithSearch)type;
- (void)searchUitls:(NSString *)searchText;
- (void)hotSearchWithArray:(NSArray *)array;
- (void)labelSeachWithArray:(NSArray *)array;
@end
