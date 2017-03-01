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

@property (nonatomic, strong) NSString *selectedData;
@property (nonatomic, assign) NSInteger selectedIndex;
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
        self.selectedIndex = -1;
    }
    return self;
}

+ (YJDatePickerView * _Nonnull)pickDateWithCompletionHandle:(CompleteSelection _Nonnull)handler {
    
    YJDatePickerView *view = [[YJDatePickerView alloc] initWithFrame:kRootWindow.bounds];
    view.isCustomData = NO;
    view.completeSelection = handler;
    [kRootWindow addSubview:view];
    [view displayView];
    return view;
}

+ (YJDatePickerView * _Nonnull)pickCustomDataWithArray:(NSArray *_Nonnull)data completionHandle:(CompleteSelection _Nonnull)handler {
    YJDatePickerView *view = [[YJDatePickerView alloc] initWithFrame:kRootWindow.bounds];
    view.isCustomData = YES;
    view.completeSelection = handler;
    view.dataSource = [data copy];
    [view.picker reloadAllComponents];
    [kRootWindow addSubview:view];
    [view displayView];
    return view;
}


#pragma mark - 控制数据

- (void)confirmData {
    id data = !self.isCustomData ? self.datePicker.date : self.selectedData;
    
    if (self.completeSelection) {
        self.completeSelection(self.selectedIndex, data);
    }
    if ([self.delegate respondsToSelector:@selector(selectedData:sender:)]) {
        [self.delegate selectedData:data sender:self];
    }
    [self dissmissView];
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
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count + 1;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"请选择";
    } else {
        if ([self.dataSource[row - 1] isKindOfClass:[NSString class]]) {
            return self.dataSource[row -1];
        }
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        return;
    }
    self.selectedData = self.dataSource[row -1];
    self.selectedIndex = row;
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
