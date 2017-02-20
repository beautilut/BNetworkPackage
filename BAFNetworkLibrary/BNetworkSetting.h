//
// Created by Beautilut on 2017/2/15.
// Copyright (c) 2017 beautilut. All rights reserved.
//

static NSString *const BRNormalErrorDomain = @"BRNormalErrorDomain";
static NSString *const BHTTPRequestErrorDomain = @"HTTPRequestErrorDomain";

typedef enum {
    EBHTTPRequestResponseTypeString = 0 ,
    EBHTTPRequestResponseTypeData
} EBHTTPRequestResponseType;

typedef enum : NSUInteger {
    EBReadCacheErrorCodeUnknown = 0 ,
    EBReadCacheErrorCodeCacheEmpty ,
    EBReadCacheErrorCodeCacheExpired
} EBReadCacheErrorCode;

typedef enum : NSInteger {
    EBProviderPriorityVeryLow = -8L,
    EBProviderPriorityLow = -4L,
    EBProviderPriorityNormal = 0,
    EBProviderPriorityHigh = 4,
    EBProviderPriorityVeryHigh = 8
} EBProviderPriority;

typedef enum : NSUInteger {
    EBProviderStatusIdle = 0,    //空闲不请求中
    EBProviderStatusWaiting ,    //请求等待中
    EBProviderStatusSend,        //处于请求中
    EBProviderStatusCacheSaving, //处于缓存中
    EBProviderStatusParse        //处于解析中
} EBProviderStatus;

typedef enum : NSUInteger {
    BNetworkErrorFailure = 0 , //请求失败
    BNetworkErrorTimedOut ,    //超时
    BNetworkErrorCancelled,    //取消
    BNetworkErrorAuthentication , //认证错误
    BNetworkErrorUnableToCreateRequest , //创建请求失败
    BNetworkErrorInternalWhileBuildingRequest ,     //网络在创建请求时错误
    BNetworkErrorInternalWhileApplyingCredentials , //网络在请求证书时错误
    BNetworkErrorFileManager , //文件管理错误
    BNetworkErrorMuchRedirection , //过多重定向错误
    BNetwrokErrorUnhandledException , //未处理异常
    BNetworkErrorCompression   //压缩错误
} BNetworkErrorType;
