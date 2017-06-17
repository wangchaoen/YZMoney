//
//  YZPickerView.h
//  YZMoney
//
//  Created by 7仔 on 15/11/24.
//  Copyright © 2015年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface YZPickerView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) void (^pickerDoneBlock)(NSString *);

- (void)show;

@end
