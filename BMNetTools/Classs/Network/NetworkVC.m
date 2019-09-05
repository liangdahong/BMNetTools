//
//  NetworkVC.m
//  BMMacTools
//
//  Created by __liangdahong on 2017/2/26.
//  Copyright © 2017年 http://idhong.com/. All rights reserved.
//

#import "NetworkVC.h"
#import "NSObject+Newwork.h"

@implementation NetworkVC

- (IBAction)okButtonClick:(id)sender {

    // 1、获取类型数组
    NSArray <NewworkModel *> *arr = [NSObject bm_newworkModelArrayWithString:self.textView.string];

    // 2、头文件内容
    NSMutableString *headerString = @"".mutableCopy;

    // 3、创建 h m 文件
    [arr enumerateObjectsUsingBlock:^(NewworkModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 创建h文件
        [NSObject bm_creatHFileStringWithNewworkModel:obj];
        // 创建m文件
        [NSObject bm_creatMFileStringWithNewworkModel:obj];
        // 添加宏
        [headerString appendString:obj.macroName];
    }];

    // 显示出去
    NSMutableString *str1 = self.textView.string.mutableCopy;
    [str1 appendString:@"\n\n\n"];
    [str1 appendString:headerString];
    self.textView.string = str1.copy;
}

@end
