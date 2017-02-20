//
// Created by Beautilut on 2017/2/15.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDownloadCache.h"

extern const NSTimeInterval BSecondsByMinute;
extern const NSTimeInterval BSecondsByHour;
extern const NSTimeInterval BSecondsByDay;
extern const NSTimeInterval BSecondsByWeek;
extern const NSTimeInterval BSecondsByYear;


typedef enum : NSUInteger {
    EBCachePolicyNetworkFirst = 0 ,     //不读取缓存
    EBCachePolicyCacheFirst ,           //缓存优先 ， 没有缓存/缓存过期才请求网络
    EBCachePolicyCacheAlwaysRead        //只要缓存存在，不管是否过期，始终读取
} EBCachePolicy;

@interface BCacheInfo : NSObject

@property  (nonatomic , assign) EBCachePolicy cachePolicy;

@property  (nonatomic , assign) NSTimeInterval cacheSecond;

@property  (nonatomic , retain) BDownloadCache * downloadCache;

@end