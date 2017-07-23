//
//  YJDatePickerView.m
//  YJDatePicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import "YJDatePickerView.h"
#import "AppDelegate.h"
#define kRootWindow  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window

static CGFloat mainViewHeight, screenHeight;
static CGFloat mainViewWidth, screenWidth;
@interface YJDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSMutableDictionary *selectedIndexDictionary;
@property (nonatomic, strong) NSMutableDictionary *selectedValueDictionary;

@property (nonatomic, assign) NSInteger selectedIndex;//DatePicker使用的index
@property (nonatomic, assign) BOOL isCustomData;
@end

@implementation YJDatePickerView

#pragma mark - 初始化视图

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        mainViewHeight = screenHeight * 0.42;
        mainViewWidth = screenWidth;
        self.backgroundColor = [UIColor clearColor];
        self.selectedIndexDictionary = [NSMutableDictionary new];
        self.selectedValueDictionary = [NSMutableDictionary new];
        self.selectedIndex = -1;
    }
    return self;
}

+ (YJDatePickerView * _Nonnull)pickDateWithCompletionHandle:(CompleteSelection _Nonnull)handler defaultValue:(BOOL)isDefault {
    
    YJDatePickerView *view = [[YJDatePickerView alloc] initWithFrame:kRootWindow.bounds];
    view.isNeedDefault = isDefault;
    view.isCustomData = NO;
    view.completeSelection = handler;
    [kRootWindow addSubview:view];
    [view displayView];
    return view;
}

+ (YJDatePickerView * _Nonnull)pickCustomDataWithArray:(NSArray *_Nonnull)data completionHandle:(CustomCompleteHandler _Nonnull)handler defaultValue:(BOOL)isDefault{
    YJDatePickerView *view = [[YJDatePickerView alloc] initWithFrame:kRootWindow.bounds];
    view.isNeedDefault = isDefault;
    view.isCustomData = YES;
    view.customCompleteHandler = handler;
    view.dataSource = [data copy];
    [view.picker reloadAllComponents];
    [kRootWindow addSubview:view];
    [view displayView];
    return view;
}


#pragma mark - 控制数据

- (void)confirmData {
    [self checkEmptyData];
    id data = !self.isCustomData ? self.datePicker.date : self.selectedValueDictionary.allValues;
    if (self.completeSelection) {
        self.completeSelection(self.selectedIndex, data);
    }
    if (self.customCompleteHandler) {
        self.customCompleteHandler([self.selectedIndexDictionary copy], [self.selectedValueDictionary copy]);
    }
    if ([self.delegate respondsToSelector:@selector(selectedData:sender:)]) {
        [self.delegate selectedData:data sender:self];
    }
    [self dissmissView];
}

- (void)checkEmptyData {
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSArray   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.selectedIndexDictionary objectForKey:[NSString stringWithFormat:@"%ld", idx]]) {
            [self.selectedIndexDictionary setObject:obj.firstObject forKey:[NSString stringWithFormat:@"%ld", idx]];
        }
        if (![self.selectedValueDictionary objectForKey:[NSString stringWithFormat:@"%ld", idx]]) {
            [self.selectedValueDictionary setObject:obj.firstObject forKey:[NSString stringWithFormat:@"%ld", idx]];
        }
    }];
    
}

#pragma mark - 控制视图的展示

- (void)displayView {
    self.bgView.alpha = 0;
    self.mainView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.6;
        self.mainView.frame = CGRectMake(0, screenHeight - mainViewHeight, mainViewWidth, mainViewHeight);
    }];
}

- (void)dissmissView {
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = CGRectMake(0, screenHeight, mainViewWidth, mainViewHeight);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *array = self.dataSource[component];
    if (self.isNeedDefault) {
        return array.count + 1;
    } else {
        return array.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *array = self.dataSource[component];
    if (self.isNeedDefault) {
        if (row == 0) {
            return @"请选择";
        } else {
            if ([array[row - 1] isKindOfClass:[NSString class]]) {
                return array[row -1];
            }
            return nil;
        }
    } else {
        if ([array[row] isKindOfClass:[NSString class]]) {
            return array[row];
        }
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *array = self.dataSource[component];
    if (self.isNeedDefault) {
        if (row == 0) {
            return;
        }
        [self.selectedIndexDictionary setObject:[NSString stringWithFormat:@"%ld", row - 1] forKey:[NSString stringWithFormat:@"%ld", component]];
        [self.selectedValueDictionary setObject:array[row - 1] forKey:[NSString stringWithFormat:@"%ld", component]];
        self.selectedIndex = row - 1;
    } else {
        [self.selectedIndexDictionary setObject:[NSString stringWithFormat:@"%ld", row] forKey:[NSString stringWithFormat:@"%ld", component]];
        [self.selectedValueDictionary setObject:array[row] forKey:[NSString stringWithFormat:@"%ld", component]];
        self.selectedIndex = row;
    }
}

#pragma mark - 构建视图

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
        _bgView.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:0.6];
        [self addSubview:_bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissView)];
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}


- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, mainViewWidth, mainViewHeight)];
        _mainView.backgroundColor = [UIColor whiteColor];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(15, 15, 30, 20)];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
         [cancelBtn setTintColor:[UIColor lightGrayColor]];
        [cancelBtn addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:cancelBtn];
        
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setFrame:CGRectMake(screenWidth - 45, 15, 30, 20)];
        [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [confirmBtn setTintColor:[UIColor colorWithRed:118 / 255.0 green:172 / 255.0 blue:248 / 255.0 alpha:1]];
        [confirmBtn addTarget:self action:@selector(confirmData) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:confirmBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 46, screenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
        [_mainView addSubview:line];
        if (self.isCustomData) {
            [_mainView addSubview:self.picker];
        } else {
            [_mainView addSubview:self.datePicker];
        }
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 47, mainViewWidth, mainViewHeight - 47)];
        _picker.delegate = self;
        _picker.dataSource = self;
    }
    return _picker;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 47, mainViewWidth, mainViewHeight - 47)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_datePicker setDate:[NSDate date] animated:YES];
//        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

@end
