//
//  NSObject+Newwork.h
//  BMNetTools
//
//  Created by liangdahong on 2019/9/5.
//  Copyright © 2019 http://idhong.com/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewworkModel.h"
#import "BMBaseTokenAPIManager.h"

/*

211.3-收衣派单-指派
地址：/washingService-controller/wash/dispatchOrder/dispatchingOrder22

2111.3-收衣派单-指派
地址：/washingService-controller/wash/dispatchOrder/dispatchingOrder2

2111.3-收衣派单-指派
地址：/washingService-controller/wash/dispatchOrder/dispatchingOrder1

 */

#define url_fix_utf @"地址："
#define url_fix @"/washingService-controller/"

#define user_path @"/Users/Mac/Desktop/temp/"

#define import_base_class @"BMBaseTokenAPIManager"


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Newwork)

+ (NSArray <NewworkModel *> *)bm_newworkModelArrayWithString:(NSString *)str;

+ (void)bm_creatHFileStringWithNewworkModel:(NewworkModel *)model;
+ (void)bm_creatMFileStringWithNewworkModel:(NewworkModel *)model;

@end

NS_ASSUME_NONNULL_END
