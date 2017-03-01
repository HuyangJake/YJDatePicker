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
    YJDatePickerView *view = [YJDatePickerView pickDateWithCompletionHandle:^(NSInteger index, id  _Nullable value) {
        
    }];
    view.delegate = self;
}


- (IBAction)showCustom:(id)sender {
    YJDatePickerView *view = [YJDatePickerView pickCustomDataWithArray:@[@"一月", @"二月", @"三月",@"四月",@"五月",@"六月",@"七月",@"八月"] completionHandle:^(NSInteger index, id  _Nullable value) {
        NSLog(@"block: index :%ld, %@", index, value);
    }];
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
