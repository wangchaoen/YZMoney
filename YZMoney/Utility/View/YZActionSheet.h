//
//  YZActionSheet.h
//  YZMoney
//
//  Created by 7仔 on 15/12/25.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlack)(NSInteger i);

@interface YZActionSheet : UIView

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) id shareImage;
@property (nonatomic, copy) ActionBlack black;

- (instancetype)initWithID:(NSDictionary *)dicID arrMore:(NSArray *)arrMore arrShare:(NSArray *)arrShare;
- (void)show;

@end
