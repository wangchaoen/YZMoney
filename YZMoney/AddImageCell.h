//
//  AddImageCell.h
//  YZMoney
//
//  Created by 王朝恩 on 2017/3/1.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddImageCellDelegate <NSObject>

- (void)addImageDelegateImage:(UIView *)view index:(NSIndexPath *)index;
@optional
- (void)addImageLongTap:(UIView *)view index:(NSIndexPath *)index;
@end

@interface AddImageCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *lastImage;
@property (nonatomic, assign) id<AddImageCellDelegate> delegate;

@property (nonatomic, assign, getter=isShowAddImage) BOOL showAddImage;
@property (nonatomic, assign, getter=isAddTap) BOOL addTap;
- (void)sendArrayCreatViewIndex:(NSIndexPath *)index imageArr:(NSArray *)imageArr;

- (void)sendOneImageIndex:(NSIndexPath *)index imageArr:(NSArray *)imageArr;
@end
