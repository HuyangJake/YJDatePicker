//
//  YJDatePickerView.h
//  YJDatePicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJDatePickerView;
//《备用》，可使用BLOCK回调
@protocol YJDatePickerDelegate <NSObject>

@optional
- (void)selectedData:(id _Nullable)data sender:(YJDatePickerView * _Nonnull)aView;

@end

//DatePicker使用的回调
typedef void (^CompleteSelection)(NSInteger index, _Nullable id value);

/*DataPicker使用的回调
 返回的两个字典都是以 数据源数组位置为key， 选择的位置索引值 或者 数组中该位置对应的值 为value
 */
typedef void (^CustomCompleteHandler)(NSDictionary *_Nonnull selectedIndexDic, NSDictionary *_Nonnull selectedValueDic);

@interface YJDatePickerView : UIView

@property (nonatomic, weak) _Nullable id <YJDatePickerDelegate>delegate;

@property (nonatomic, copy, nonnull) void (^completeSelection)(NSInteger index, _Nullable id value);

@property (nonatomic, copy, nonnull) void (^customCompleteHandler)(NSDictionary *_Nonnull selectedIndexDic, NSDictionary *_Nonnull selectedValueDic);

@property (nonatomic, assign) BOOL isNeedDefault;//是或否需要默认的“请选择”栏目  默认NO

/**
 默认选择仅日期
 */
+ (YJDatePickerView * _Nonnull)pickDateWithCompletionHandle:(CompleteSelection _Nonnull)handler defaultValue:(BOOL)isDefault;


/**
  传入自定义数组进行选择

  @param _Nonnull 包含的数组（Component的数组）
  @return YJDatePickerView
  
*/
+ (YJDatePickerView * _Nonnull)pickCustomDataWithArray:(NSArray *_Nonnull)data completionHandle:(CustomCompleteHandler _Nonnull)handler defaultValue:(BOOL)isDefault;


@end
