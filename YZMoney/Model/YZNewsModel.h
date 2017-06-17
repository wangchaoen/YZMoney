//
//  YZNewsModel.h
//  YZMoney
//
//  Created by 7仔 on 15/11/11.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import "YZBaseModel.h"





@interface YZNewsModel : YZBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *beanDescription;
@property (nonatomic, copy) NSString *beanName;
@property (nonatomic, copy) NSString *cacheKey;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger hint;
@property (nonatomic, assign) NSTimeInterval publishDate;

@property (nonatomic, strong) NSArray *keyWord;
@property (nonatomic, strong) NSDictionary *category;

@property (nonatomic, copy) NSString *shareUrl;
@end
