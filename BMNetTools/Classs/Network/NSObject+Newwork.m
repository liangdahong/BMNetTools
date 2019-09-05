//
//  NSObject+Newwork.m
//  BMNetTools
//
//  Created by liangdahong on 2019/9/5.
//  Copyright © 2019 http://idhong.com/. All rights reserved.
//

#import "NSObject+Newwork.h"

NSFileManager *fileManager;

@implementation NSObject (Newwork)

+ (NSArray <NewworkModel *> *)bm_newworkModelArrayWithString:(NSString *)string {
    // 创建文件夹
    fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:user_path withIntermediateDirectories:YES attributes:nil error:nil];

    NSMutableArray <NewworkModel*> *muarray = @[].mutableCopy;
    NSArray <NSString *> *array = [string componentsSeparatedByString:@"\n\n"];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSArray <NSString *> *arr1 = [obj componentsSeparatedByString:@"\n"];

        if (arr1.count == 2) {

            NSString *name = [arr1[1] componentsSeparatedByString:url_fix][1];
            NSMutableArray <NSString *> *arr = [name componentsSeparatedByString:@"/"].mutableCopy;

            NSMutableString *strname = @"BM".mutableCopy;
            [strname appendString:([arr[0] substringWithRange:NSMakeRange(0, 1)]).uppercaseString];
            [strname appendString:([arr[0] substringWithRange:NSMakeRange(1, arr[0].length-1)])];
            [arr removeObjectAtIndex:0];
            [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *str1 = [obj substringWithRange:NSMakeRange(0, 1)];
                str1 = str1.uppercaseString;
                [strname appendString:str1];
                [strname appendString:[obj substringWithRange:NSMakeRange(1, obj.length-1)]];
            }];
            [strname appendString:@"APIManager"];

            // 网络管理者类名
            NSString *className = strname.copy;
            // 注释
            NSString *zhus = arr1[0];
            // url
            NSString *url = [arr1[1] substringWithRange:NSMakeRange(url_fix_utf.length, arr1[1].length-url_fix_utf.length)];;
            // 宏
            NSMutableString *macroName = @"".mutableCopy;
            [macroName appendFormat:@"#define INTERFACE_%@_URL @\"%@\" ///< %@\n", className, url, zhus];
            NewworkModel *model = NewworkModel.new;
            model.className = className;
            model.url       = url;
            model.comment = zhus;
            model.macroName = macroName;
            model.macroName_url = [NSString stringWithFormat:@"INTERFACE_%@_URL", className];
            [muarray addObject:model];
        }
    }];
    return muarray;
}

+ (void)bm_creatHFileStringWithNewworkModel:(NewworkModel *)model {
    // 获取h文件路径
    NSString *hfile = [NSString stringWithFormat:@"%@%@",user_path, model.className];
    [fileManager createDirectoryAtPath:hfile withIntermediateDirectories:YES attributes:nil error:nil];

    NSString *filePath_h = [NSString stringWithFormat:@"%@/%@.h", hfile, model.className];
    // 初始化字符串
    NSMutableString *str_h = @"".mutableCopy;

    // 版权信息
    [str_h appendString:@"//\n"];
    [str_h appendFormat:@"//  %@.h\n", model.className];
    [str_h appendString:@"//  \n"];
    [str_h appendFormat:@"//  Created by ___liangdahong on %@.\n", [NSDate date].description];
    [str_h appendFormat:@"//  Copyright © 月亮小屋（中国）有限公司. All rights reserved.\n"];
    [str_h appendString:@"//  \n"];
    [str_h appendString:@"//  本文件由（ https://github.com/liangdahong/BMNetTools ）自动生成\n"];
    [str_h appendString:@"//  \n\n"];

    [str_h appendFormat:@"#import \"%@.h\"\n\n", import_base_class];
    [str_h appendString:@"/**\n"];
    // 注释内容
    [str_h appendString:model.comment];
    [str_h appendString:@"\n*/\n"];
    [str_h appendFormat:@"@interface %@ : %@\n\n@end\n", model.className, import_base_class];
    // 创建文件
    [str_h writeToFile:filePath_h atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)bm_creatMFileStringWithNewworkModel:(NewworkModel *)model {
    // 获取m文件路径
    NSString *filePath_m = [NSString stringWithFormat:@"%@%@/%@.m",user_path, model.className, model.className];
    NSMutableString *str_m =  @"".mutableCopy;

    // 版权信息
    [str_m appendString:@"//\n"];
    [str_m appendFormat:@"//  %@.m\n", model.className];
    [str_m appendString:@"//  \n"];
    [str_m appendFormat:@"//  Created by ___liangdahong on %@.\n", [NSDate date].description];
    [str_m appendFormat:@"//  Copyright © 月亮小屋（中国）有限公司. All rights reserved.\n"];
    [str_m appendString:@"//  \n"];
    [str_m appendString:@"//  本文件由（ https://github.com/liangdahong/BMNetTools ）自动生成\n"];
    [str_m appendString:@"//  \n\n"];

    [str_m appendFormat:@"#import \"%@.h\"\n\n", model.className];
    [str_m appendFormat:@"@implementation %@\n\n", model.className];
    [str_m appendFormat:@"- (NSString *)interfaceUrl {\n    return %@;\n}\n\n", model.macroName_url];
    [str_m appendString:@"- (BOOL)useToken {\n    return YES;\n}\n\n@end"];
    [str_m writeToFile:filePath_m atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
