//
//  BProviderManager.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "BProviderManager.h"
#import "BAFMsgCreator.h"

@interface BProviderManager () <BProviderManagerResponseDelegate>

@property (nonatomic , strong) NSMutableArray * providerArray; //请求数组

@end

static BProviderManager * providerManager = nil;
@implementation BProviderManager

+(BProviderManager*)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!providerManager) {
            providerManager = [[BProviderManager alloc] init];
        }
    });
    return providerManager;
}


-(void)sendProvider:(BBaseProvider *)provider
{
    
    //封装参数
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:[provider parameters]];
    //填充默认参数
    [params addEntriesFromDictionary:nil];
    
    //请求签名
    
    //拼装url
    NSString * urlString = provider.urlString;
    
    //判断缓存
    id <NSCoding> cacheObject = nil;
    
    if (cacheObject) {
        
    }else{
        //没有缓存 直接 发送请求
        [self.creator operationWithProvider:provider withUrlString:urlString withParams:params];
    }
    
}

#pragma mark - BProviderManagerResponseDelegate -

-(void)requestStarted:(NSObject *)request
{
    
}

-(void)requestFinished:(NSObject *)request
{
    
}

-(void)requestFailed:(NSObject *)request error:(NSError *)error
{
    
}

-(void)request:(NSObject *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

#pragma mark -- setter & getter --

-(id<BProviderManagerRequestDelgate>)creator
{
    @synchronized (self) {
        if (!_creator) {
            _creator = [[BAFMsgCreator alloc] init];
            
            _creator.responseDelegate = self;
            
        }
    }
    
    return _creator;
}
@end
