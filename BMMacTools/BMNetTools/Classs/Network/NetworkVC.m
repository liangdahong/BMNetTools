//
//  NetworkVC.m
//  BMMacTools
//
//  Created by __liangdahong on 2017/2/26.
//  Copyright © 2017年 http://idhong.com/. All rights reserved.
//

#import "NetworkVC.h"

@interface NetworkVC ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation NetworkVC


- (IBAction)okButtonClick:(id)sender {

    NSMutableArray <NSDictionary <NSString *, NSString *>*>*muarray = @[].mutableCopy;
    NSString *string = self.textView.string.mutableCopy;
    NSArray <NSString *> *array = [string componentsSeparatedByString:@"\n\n"];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString *> *arr1 = [obj componentsSeparatedByString:@"\n"];
        if (arr1.count == 2) {
            NSString *name =  [arr1[1] componentsSeparatedByString:@"/officeAuto-controller/"][1];
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
            NSLog(@"标注:%@  类名：%@",arr1[0], strname);
            [muarray addObject:@{@"clas":strname, @"clasTitle":arr1[0], @"clasUrl": arr1[1] }];
        }
    }];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager createDirectoryAtPath:@"/Users/___liangdahong/Desktop/temp" withIntermediateDirectories:YES attributes:nil error:nil];

    // 生成类文件
    [muarray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSString *filePath_h_1 = [NSString stringWithFormat:@"/Users/___liangdahong/Desktop/temp/%@", obj[@"clas"]];
        [fileManager createDirectoryAtPath:filePath_h_1 withIntermediateDirectories:YES attributes:nil error:nil];

        
        NSString *filePath_h = [NSString stringWithFormat:@"%@/%@.h",filePath_h_1, obj[@"clas"]];
        NSString *filePath_m = [NSString stringWithFormat:@"%@/%@.m",filePath_h_1, obj[@"clas"]];

        
        NSMutableString *str_h = @"".mutableCopy;
        {
            [str_h appendString:@"#import \"BMBaseAPIManager.h\"\n\n"];
            [str_h appendString:@"/**\n"];
            [str_h appendString:obj[@"clasTitle"]];
            [str_h appendString:@"\n*/\n"];
            [str_h appendFormat:@"@interface %@ : BMBaseAPIManager\n\n@end\n", obj[@"clas"]];
        }
        
        NSString *net_url = [NSString stringWithFormat:@"INTERFACE_%@_URL", obj[@"clas"]];

        NSMutableString *str_m =  @"".mutableCopy;
        {

            [str_m appendFormat:@"#import \"%@.h\"\n\n", obj[@"clas"]];
            [str_m appendFormat:@"@implementation %@\n\n", obj[@"clas"]];
            [str_m appendFormat:@"- (NSString *)interfaceUrl {\n    return %@;\n}\n\n", net_url];
            [str_m appendString:@"- (BOOL)useToken {\n    return YES;\n}\n\n@end"];
        }
        [str_h writeToFile:filePath_h atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [str_m writeToFile:filePath_m atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }];
    
    NSMutableString *mustrhhh = @"".mutableCopy;
    [muarray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *net_url = [NSString stringWithFormat:@"INTERFACE_%@_URL", obj[@"clas"]];
        [mustrhhh appendFormat:@"#define %@       @\"%@\" ///< %@\n", net_url, [obj[@"clasUrl"] componentsSeparatedByString:@"地址："][1], obj[@"clasTitle"]];
    }];
    [mustrhhh writeToFile:@"/Users/___liangdahong/Desktop/temp/aaaa.h" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
