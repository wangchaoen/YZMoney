//
//  YZCityView.m
//  YZMoney
//
//  Created by 王朝恩 on 2017/4/28.
//  Copyright © 2017年 yzmoney. All rights reserved.
//

#import "YZCityView.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2


@interface YZCityView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}

@end

@implementation YZCityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView {
    self.backgroundColor = RGBColor(0, 0, 0, 0);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelRmoveView)];
    [self addGestureRecognizer:tap];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, S_H - 180, S_W, 180)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [self addSubview: picker];
    
    selectedProvince = [province objectAtIndex: 0];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(picker.frame) - 40, S_W, 40)];
    titleView.backgroundColor = RGBColor(244, 244, 244, 1);
    [self addSubview:titleView];
    
    UIButton *canelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    canelBut.frame = CGRectMake(0, 0, 60, 40);
    canelBut.titleLabel.font = MidFont;
    [canelBut setTitle:@"取消" forState:UIControlStateNormal];
    [canelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canelBut addTarget:self action:@selector(cancelRmoveView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:canelBut];
    button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitle: @"完成" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = MidFont;
    [button setFrame: CGRectMake(S_W - 60, 0, 60, 40)];
    [button setTintColor:[UIColor grayColor]];
    [button addTarget: self action: @selector(buttobClicked:) forControlEvents: UIControlEventTouchUpInside];
    [titleView addSubview:button];
}
#pragma mark- button clicked

- (void) buttobClicked:(id)sender {
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@%@%@", provinceStr, cityStr, districtStr];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCityNameWith:view:)]) {
        [self.delegate chooseCityNameWith:showMsg view:self];
    }
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSArray alloc] initWithArray: array];
    
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [picker reloadComponent: DISTRICT_COMPONENT];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.backgroundColor = [UIColor clearColor];
    }
    return myView;
}
#pragma mark - action
- (void)cancelRmoveView {
//    [self removeFromSuperview];
    self.hidden = YES;
}


@end
