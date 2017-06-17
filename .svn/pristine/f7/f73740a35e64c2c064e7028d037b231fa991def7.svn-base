//
//  YZProductFilterTV.h
//  YZMoney
//
//  Created by 7仔 on 15/11/10.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ComeType){
    ComeTypeWithProdect = 0,
    ComeTypeWithIndex = 1
};


@interface YZProductFilterTV : UITableView
@property (nonatomic, strong) UIVisualEffectView *viewVisual;

@property (nonatomic, copy) void(^filterDoneBlock)(NSDictionary *parameters);
@property (nonatomic, copy) void(^determineBlock)();
@property (nonatomic, copy) NSArray *arrCondition;

@property (nonatomic, copy) NSString *typeName;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style data:(NSArray *)data;

@property (nonatomic, assign) ComeType comeType;
//新展示方法
- (void)showTableView;
- (void)removeTableView;

@end
