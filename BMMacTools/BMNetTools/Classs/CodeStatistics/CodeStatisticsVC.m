//
//  CodeStatisticsVC.m
//  BMMacTools
//
//  Created by __liangdahong on 2017/2/26.
//  Copyright © 2017年 http://idhong.com/. All rights reserved.
//

#import "CodeStatisticsVC.h"
NSMutableArray *arr;

NSUInteger caculateLineNumberofFile(NSString *path, NSArray <NSString *> *names)
{
    // 代码行数
    
    NSUInteger count = 0;

    //得到文件管理这个类
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //对给的路径进行分析，是文件夹还是文件
    
    BOOL isDir = NO;
    
    //给的路径是否存在
    
    BOOL exist = [mgr fileExistsAtPath:path isDirectory:&isDir];
    
    
    //路径不存在，程序结束
    
    if(!exist) return 0;
    
    //判断给出的路径是否是文件夹还是文件
    
    if(isDir)
    {
        
        //如果是文件夹的话，把该文件夹中所有的文件的文件名放入array中
        
        NSArray *array = [mgr contentsOfDirectoryAtPath:path error:nil];
        
        //从array拿出每个文件的文件名，与先前的文件路径组合成新的文件路径。
        
        for(NSString *fileName in array)
        
        {
            
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
            
            //计算出新路径中文件的代码行数，并与前面的相加
            
            count +=caculateLineNumberofFile(newPath, names);
            
        }
        
        return count;
    }
    else
    {
        // 拿到文件的扩展名
        
        NSString *extension = [path pathExtension];
        
        //只对.m 、.h、.c文件进行代码量计算，不是上面文件的跳过
        
        if(![extension isEqualToString:@"m" ]&&![extension isEqualToString:@"h"]&&![extension isEqualToString:@"c"])
        
        return 0;
        
        // 获得文件中的内容
        
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil ];
        
        //利用\n来分割代码，得到每一行的代码将其作为数组的一个元素
        
        NSArray *code = [content componentsSeparatedByString:@"\n"];
        
        
        if (names.count != 0) {
            for (NSString *str in names) {
                if ( [content rangeOfString:str].location != NSNotFound) {
                    //打印出每个文件包含的代码数
                    [arr addObject:@{@"file" : [[path componentsSeparatedByString:@"/"] lastObject], @"LINE" : [NSString stringWithFormat:@"%ld", code.count]}];
                    
                    //最终数组的个数就是要求代码行数，返回
                    return code.count;
                }
            }
            return 0;
        }else {
            //打印出每个文件包含的代码数
            
            [arr addObject:@{@"file" : [[path componentsSeparatedByString:@"/"] lastObject], @"LINE" : [NSString stringWithFormat:@"%ld", code.count]}];
            
            //最终数组的个数就是要求代码行数，返回
            return code.count;
        }
    }
}


@interface CodeStatisticsVC ()
@property (weak) IBOutlet NSTextField *filePathTextField;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (unsafe_unretained) IBOutlet NSTextView *textView2;
@property (weak) IBOutlet NSTextField *PRlABEL;
@property (weak) IBOutlet NSTextField *userNameTextFiled;

@end

@implementation CodeStatisticsVC
    
- (IBAction)buttonClick:(id)sender {

    arr = [@[] mutableCopy];
    
    self.PRlABEL.stringValue = @"正在统计...";

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        
        NSUInteger line = caculateLineNumberofFile(self.filePathTextField.stringValue, self.userNameTextFiled.stringValue.length > 1 ? [self.userNameTextFiled.stringValue componentsSeparatedByString:@","] : @[]);
        
        
        [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1[@"LINE"] integerValue] > [obj2[@"LINE"] integerValue];
        }];
        NSMutableString *string = [NSMutableString string];
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx) {
                if ([obj[@"LINE"] integerValue] != [arr[idx-1][@"LINE"] integerValue]) {
                    [string appendString:@"\n\n"];
                    [string appendString:obj[@"file"]];
                    [string appendString:@" : "];
                    [string appendString:obj[@"LINE"]];
                } else {
                    [string appendString:@"\n"];
                    [string appendString:obj[@"file"]];
                    [string appendString:@" : "];
                    [string appendString:obj[@"LINE"]];
                }
            }else {
                [string appendString:@"\n"];
                [string appendString:obj[@"file"]];
                [string appendString:@" : "];
                [string appendString:obj[@"LINE"]];
            }
        }];
        
        self.textView.string = string;
        
        self.textView2.string =
        
        [NSString stringWithFormat:@"共 %ld个源文件\n共 %ld行代码\n代码行数为多为%@ %ld \n代码行数为少为 %@ %ld"
         ,arr.count,
         line,
         [arr lastObject][@"file"],
         [[arr lastObject][@"LINE"] integerValue],
         [arr firstObject][@"file"],
         [[arr firstObject][@"LINE"] integerValue]];
        self.PRlABEL.stringValue = @"";
    });
}
@end
