//
//  SearchHisModel.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/9.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZBaseModel.h"

@interface SearchHisModel : YZBaseModel
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *column;
@end