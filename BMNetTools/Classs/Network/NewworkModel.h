//
//  NewworkModel.h
//  BMNetTools
//
//  Created by liangdahong on 2019/9/5.
//  Copyright © 2019 http://idhong.com/. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewworkModel : NSObject

@property (nonatomic, copy) NSString *className; ///< 类名
@property (nonatomic, copy) NSString *url;       ///< url

/**
 #define INTERFACE_BMWashDispatchOrderDispatchingOrderAPIManager_URL @"/washingService-controller/wash/dispatchOrder/dispatchingOrder" ///< 2.3-收衣派单-指派
 */
@property (nonatomic, copy) NSString *macroName;

@property (nonatomic, copy) NSString *macroName_url; ///< INTERFACE_BMWashDispatchOrderDispatchingOrderAPIManager_URL

@property (nonatomic, copy) NSString *comment;   ///< 注释内容



@end

NS_ASSUME_NONNULL_END
