//
//  BProviderManager.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "BProviderManager.h"

@implementation BProviderManager


-(void)sendProvider:(BBaseProvider *)provider
{
    if ([provider.httpMethod isEqualToString:@"POST"]) {
        [self postWithProvider:provider];
    }else if([provider.httpMethod isEqualToString:@"GET"]) {
        [self getWithProvider:provider];
    }
}

//参数带在header里
-(void)postWithProvider:(BBaseProvider *)provider
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    //传递参数
    NSDictionary * parameters = [provider parameters];
    
    //url
    NSString * url = [NSString stringWithFormat:@"%@/%@",baseUrl,provider.method];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//参数带在URL里
-(void)getWithProvider:(BBaseProvider *)provider
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    NSDictionary * parameters = [provider parameters];
    
    [manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
