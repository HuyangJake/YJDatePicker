//
//  YJDatePickerView.h
//  YJDatePicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJDatePickerView;
@protocol YJDatePickerDelegate <NSObject>

@optional
- (void)selectedData:(id _Nullable)data sender:(YJDatePickerView * _Nonnull)aView;

@end

typedef void (^CompleteSelection)(NSInteger index, _Nullable id value);

@interface YJDatePickerView : UIView

@property (nonatomic, weak) _Nullable id <YJDatePickerDelegate>delegate;

@property (nonatomic, copy, nonnull) void (^completeSelection)(NSInteger index, _Nullable id value);

/**
 默认选择仅日期
 */
+ (YJDatePickerView * _Nonnull)pickDateWithCompletionHandle:(CompleteSelection _Nonnull)handler;

/**
 传入自定义数组进行选择，默认支持单栏目选择
 */
+ (YJDatePickerView * _Nonnull)pickCustomDataWithArray:(NSArray *_Nonnull)data completionHandle:(CompleteSelection _Nonnull)handler;

@end
