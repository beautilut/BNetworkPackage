//
//  BAFRequestManager.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 2017/2/7.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import "BAFRequestManager.h"

@interface BAFRequestManager ()

@property (nonatomic , strong) AFHTTPSessionManager * manager;

@end


@implementation BAFRequestManager

+(BAFRequestManager*)manager
{
    static dispatch_once_t onceToken;
    static BAFRequestManager * shareManager;
    dispatch_once(&onceToken, ^{
        shareManager = [[BAFRequestManager alloc] init];
    });
    return shareManager;
}


#pragma mark  -
-(id)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        
        
//        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        
//        _manager.requestSerializer.timeoutInterval = 30;
    }
    return self;
}



#pragma mark - base methods -

//get 请求
-(NSURLSessionDataTask*)get:(NSString*)urlString
               withProvider:(BBaseProvider*)provider
{
    NSDictionary * parameters = [provider parameters];
    
    NSURLSessionDataTask * requestSession = [_manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        [provider progress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [provider task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [provider task:task withError:error];
    }];
    
    return requestSession;
}

//post 请求
-(NSURLSessionDataTask*)post:(NSString*)urlString
                withProvider:(BBaseProvider*)provider
{
    NSDictionary * parameters = [provider parameters];
    
    NSURLSessionDataTask * requestSession = [_manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        [provider progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [provider task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [provider task:task withError:error];
    }];
    return requestSession;
}

//上传图片
-(NSURLSessionDataTask*)requestImage:(NSString*)urlString
                          imageDatas:(NSArray*)dataArray
                        withProvider:(BBaseProvider*)provider;
{
    
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
        [provider progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [provider task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [provider task:task withError:error];
    }];
    
    return requestTask;
}

//上传文件
-(NSURLSessionDataTask*)requestFile:(NSString*)urlString
                   withProvider:(BBaseProvider*)provider
{
    NSURLSessionDataTask * requestTask = [_manager POST:urlString parameters:provider.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        formData appendPartWithFileData:provider.fileData  name:<#(nonnull NSString *)#> fileName:<#(nonnull NSString *)#> mimeType:<#(nonnull NSString *)#>
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [provider progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [provider task:task withResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [provider task:task withError:error];
    }];
    
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

@end
