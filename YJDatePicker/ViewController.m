//
//  ViewController.m
//  YJDatePicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import "ViewController.h"
#import "YJDatePickerView.h"

@interface ViewController ()<YJDatePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)show:(id)sender {
    YJDatePickerView *view = [YJDatePickerView pickDateWithCompletionHandle:^(NSInteger index, id  _Nullable value)  {
        
    } defaultValue:YES];
    view.delegate = self;
}


- (IBAction)showCustom:(id)sender {
    NSArray *data1 = @[@"中国", @"美国", @"日本", @"俄国", @"韩国", @"英国"];
    NSArray *data2 = @[@"男生", @"女生"];
    NSArray *data3 = @[@"20岁", @"21岁", @"22岁", @"25岁", @"29岁", @"200岁"];
    YJDatePickerView *view = [YJDatePickerView pickCustomDataWithArray:@[data1, data2, data3] completionHandle:^(NSDictionary *indexDic, NSDictionary *valueDic) {
        NSLog(@"%@", indexDic);
    } defaultValue:YES];
    view.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)selectedData:(id _Nullable)data sender:(YJDatePickerView * _Nonnull)aView {
    NSLog(@"%@", data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
