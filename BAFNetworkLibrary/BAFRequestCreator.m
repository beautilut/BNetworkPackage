//
//  BAFRequestCreator.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 2017/2/16.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#define WeakObjectDef(obj) __weak typeof(obj) weak##obj = obj


#import "BAFRequestCreator.h"

@interface BAFRequestCreator ()

@property (nonatomic , strong) AFHTTPSessionManager * manager;

@end

@implementation BAFRequestCreator

+(BAFRequestCreator*)creator
{
    static BAFRequestCreator * defaultCreator;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultCreator = [[BAFRequestCreator alloc] init];
    });
    
    
    return defaultCreator;
}

-(id)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        
//        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        _manager.requestSerializer.timeoutInterval = 30;
        
    }
    return self;
}

#pragma mark  config request
-(void)configureRequest:(NSURLSessionTask *)request
           withProvider:(BBaseProvider *)provider
{
    switch (provider.requestPriority) {
        case EBProviderPriorityVeryHigh:
        {
            request.priority = 0.9;
        }
            break;
        case EBProviderPriorityHigh:
        {
            request.priority = 0.75;
        }
            break;
        case EBProviderPriorityLow:
        {
            request.priority = 0.25;
        }
            break;
        case EBProviderPriorityVeryLow:
        {
            request.priority = 0.1;
        }
            break;
        case EBProviderPriorityNormal:
        default:
        {
            request.priority = 0.5;
        }
            break;
    }

    provider.operation = request;
}

#pragma mark  - message creator -
//get 请求
-(NSURLSessionDataTask*)get:(NSString*)urlString
               withProvider:(BBaseProvider*)provider
{
    WeakObjectDef(self);
    WeakObjectDef(provider);
    NSDictionary * parameters = [provider parameters];
    
    NSURLSessionDataTask * requestSession = [_manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        [weakself provider:weakprovider withProgress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself task:task withError:error];
    }];

    [self configureRequest:requestSession withProvider:provider];

    return requestSession;
}


//post 请求
-(NSURLSessionDataTask*)post:(NSString*)urlString
                withProvider:(BBaseProvider*)provider
{
    WeakObjectDef(self);
    WeakObjectDef(provider);
    NSDictionary * parameters = [provider parameters];
    
    NSURLSessionDataTask * requestSession = [_manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        [weakself provider:weakprovider withProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself task:task withError:error];
    }];

    [self configureRequest:requestSession withProvider:provider];
    return requestSession;
}

//上传图片
-(NSURLSessionDataTask*)requestImage:(NSString*)urlString
                          imageDatas:(NSArray*)dataArray
                        withProvider:(BBaseProvider*)provider;
{
    WeakObjectDef(self);
    WeakObjectDef(provider);
    NSURLSessionDataTask * requestTask = [_manager POST:urlString parameters:provider.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0 ; i < dataArray.count ; i ++) {
            //上传时使用系统事件作为文件名
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString * str = [formatter stringFromDate:[NSDate date]];
            NSString * fileName = [NSString stringWithFormat:@"%@.png",str];
            NSString * name = [NSString stringWithFormat:@"image_%d.png",i];
            
            NSData * imageData = dataArray[i];
            
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [weakself provider:weakprovider withProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself task:task withError:error];
    }];

    [self configureRequest:requestTask withProvider:provider];

    return requestTask;
}

//上传文件
-(NSURLSessionDataTask*)requestFile:(NSString*)urlString
                       withProvider:(BBaseProvider*)provider
{
    WeakObjectDef(self);
    WeakObjectDef(provider);
    NSURLSessionDataTask * requestTask = [_manager POST:urlString parameters:provider.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        formData appendPartWithFileData:provider.fileData  name:<#(nonnull NSString *)#> fileName:<#(nonnull NSString *)#> mimeType:<#(nonnull NSString *)#>
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [weakself provider:weakprovider withProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself task:task withError:error];
    }];

    [self configureRequest:requestTask withProvider:provider];

    return requestTask;
}

#pragma mark methods

-(NSObject*)operateWithProvider:(BBaseProvider*)provider
{
    
    if ([provider.httpMethod isEqualToString:HttpMethodGET]) {
        NSURLSessionDataTask * task = [self get:provider.urlString withProvider:provider];
        [task resume];
        return  task;
    }else if ([provider.httpMethod isEqualToString:HttpMethodPOST]) {
        NSURLSessionDataTask * task = [self post:provider.urlString withProvider:provider];
        [task resume];
        return task;
    }
    
    return nil;
}


#pragma mark - handle with data -

-(void)provider:(BBaseProvider*)provider withProgress:(NSProgress*)progress
{
    if([self.responseDelegate respondsToSelector:@selector(provider:withProgress:)]){
        [self.responseDelegate provider:provider withProgress:progress];
    }
}

-(void)task:(NSURLSessionDataTask*)task withResponse:(id)responseObject
{
    if ([self.responseDelegate respondsToSelector:@selector (task:withResponse:)]) {
        [self.responseDelegate task:task withResponse:responseObject];
    }
}

-(void)task:(NSURLSessionDataTask*)task withError:(NSError*)error
{
    if ([self.responseDelegate respondsToSelector:@selector(task:withError:)]) {
        [self.responseDelegate task:task withError:error];
    }
}

@end
