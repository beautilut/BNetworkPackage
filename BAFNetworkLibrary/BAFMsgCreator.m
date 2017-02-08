//
//  BAFMsgCreator.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/9/2.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "BAFMsgCreator.h"
#import <objc/runtime.h>

@interface NSObject (ResponseStore)

@property (nonatomic , strong) NSObject * responseObject;

@end

static char ResponseObjectCharKey;
@implementation NSObject (ResponseStore)

-(void)setResponseObject:(NSObject *)responseObject
{
    objc_setAssociatedObject(self, &ResponseObjectCharKey, responseObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)responseObject
{
    return objc_getAssociatedObject(self, &ResponseObjectCharKey);
}

@end

@interface BAFMsgCreator()

@property (nonatomic, strong) AFHTTPSessionManager * manager;

@end

@implementation BAFMsgCreator

-(id)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        
    }
    return self;
}



// get 方法
-(NSURLSessionDataTask*)get:(NSString*)urlString
                 parameters:(NSDictionary*)parameters
                   provider:(BBaseProvider*)provider
{
    WeakObjectDef(self);
    
    NSURLSessionDataTask * requestSessioon = [_manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        task.responseObject = responseObject;
        [weakself requestFinished:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself requestFailed:task error:error];
    }];
    return requestSessioon;
}


//post 方法
-(NSURLSessionDataTask*)post:(NSString*)urlString
                  parameters:(NSDictionary*)parameters
                    provider:(BBaseProvider*)provider
{
    WeakObjectDef(self);
    //url
    NSURLSessionDataTask * SessionTask =  [_manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        task.responseObject = responseObject;
        [weakself requestFinished:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself requestFailed:task error:error];
    }];
    return SessionTask;
    
}

//上传单张图片
//-(NSURLSessionDataTask*)

#pragma mark BProviderManagerRequestDelgate

-(NSObject*)operationWithProvider:(BBaseProvider *)provider
                    withUrlString:(NSString *)urlString
                       withParams:(NSDictionary *)params
{
    WeakObjectDef(self);
    
    //设置获取请求时 请求头部获取
    [_manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            [weakself request:dataTask didReceiveResponseHeaders:[(NSHTTPURLResponse*)dataTask.response allHeaderFields]];
        }
        return NSURLSessionResponseAllow;
    }];
    
    if ([provider.httpMethod isEqualToString:HttpMethodGET]) {
        
        //TODO:暂不处理文件下载
        
        NSURLSessionDataTask * task = [self get:urlString parameters:params provider:provider];
        [task resume];
        return task;
        
    }else if([provider.httpMethod isEqualToString:HttpMethodPOST]) {
        //TODO:暂不处理文件上传
        
        NSURLSessionDataTask * task = [self post:urlString parameters:params provider:provider];
        [task resume];
        return task;
    }
    
    return nil;
}

-(void)cancelRequest:(NSObject *)request
{
    NSURLSessionDataTask * task = (NSURLSessionDataTask*)request;
    [task cancel];
}

-(NSInteger)responseStatusCodeWithRequest:(NSObject *)request
{
    NSURLSessionDataTask * task = (NSURLSessionDataTask*)request;
    return ((NSHTTPURLResponse*)task.response).statusCode;
}

-(NSString*)responseStringWithRequest:(NSObject *)request
{
    NSString* str = [[NSString alloc] initWithData:(id)request.responseObject encoding:NSUTF8StringEncoding];
    return str;
}

-(NSData*)responseDataWithRequest:(NSObject *)request
{
    return (id)request.responseObject;
}

#pragma mark BProviderManagerResponseDelegate

-(void)requestStarted:(NSObject*)object
{
    if ([self.responseDelegate respondsToSelector:@selector(requestStarted:)]) {
        [self.responseDelegate requestStarted:object];
    }
}

-(void)requestFinished:(NSObject*)object
{
    if ([self.responseDelegate respondsToSelector:@selector(requestFinished:)]) {
        [self.responseDelegate requestFinished:object];
    }
}

-(void)requestFailed:(NSObject*)request error:(NSError*)error
{
    if ([self.responseDelegate respondsToSelector:@selector(requestFailed:error:)]) {
        [self.responseDelegate requestFailed:request error:error];
    }
}

-(void)request:(NSObject*)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if ([self.responseDelegate respondsToSelector:@selector(request:didReceiveResponseHeaders:)]) {
        [self.responseDelegate request:request didReceiveResponseHeaders:responseHeaders];
    }
}

@end
