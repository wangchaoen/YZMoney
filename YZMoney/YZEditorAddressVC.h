//
//  YZEditorAddressVC.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/26.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZAddressModel.h"

typedef NS_ENUM(NSInteger, YZEditorAddressComeType){
    YZEditorAddressComeTypeAdd,
    YZEditorAddressComeTypeEditor
};

@interface YZEditorAddressVC : UIViewController
@property (nonatomic, assign) YZEditorAddressComeType comeType;
@property (nonatomic, strong) YZAddressModel *model;
@end
