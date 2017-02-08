///
//  BBaseProvider.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void (^ProgressHandler) (NSProgress * _Nonnull uploadProgress);
//typedef void (^SuccessHandler) (NSURLSessionDataTask * _Nonnull task , id _Nullable responseObject);
//typedef void (^FailedHandler)(NSURLSessionDataTask * _Nullable task , NSError * _Nullable error);


typedef void (^DidReceiveHandler)(long long bytes , long long totalBytes);
typedef void (^CompeleteHandler) ( id _Nullable response  , NSError *  _Nullable error);
typedef id _Nonnull (^ResponseHandler) (id _Nullable response , NSError * _Nullable error);


static NSString* const _Nullable HttpMethodGET = @"GET";
static NSString* const _Nullable HttpMethodPOST = @"POST";


@interface BFileObject : NSObject

@property (nonatomic , strong) NSData * _Nullable fileData;

@property (nonatomic , strong) NSString * _Nullable fileName;

@property (nonatomic , strong) NSString * _Nullable name;

@property (nonatomic , strong) NSString * _Nullable type;

@end


@interface BBaseProvider : NSObject

//不需要加进传参的属性

@property (nonatomic , copy) _Nullable CompeleteHandler compelteHandler; //完成的处理block

@property (nonatomic , copy) _Nullable ResponseHandler responseHandler; //解析处理block

@property (nonatomic , copy) _Nullable DidReceiveHandler receiveHandler; //获取处理block

@property (nonatomic, strong) NSString * _Nullable  method; //请求具体方法

@property (nonatomic, strong) NSString * _Nullable  httpMethod; //请求类型

@property (nonatomic , strong) NSArray * _Nullable images; //需要上传的图片
@property (nonatomic , strong) BFileObject * _Nullable fileObject; //文件数据


-(NSString* _Nullable)urlString;

-(NSDictionary* _Nullable)parameters;

@end

@interface BBaseProvider (Send)

-(void)request;

-(void)requestWithCompletionHandler:(CompeleteHandler _Nullable)compeleteHandler;

-(void)requestWithResponseHandler:(ResponseHandler _Nullable)responseHandler
             withCompeleteHandelr:(CompeleteHandler _Nullable)compeleteHandler;

@end

@interface BBaseProvider (Handle)

-(id)parseResponde:(id _Nullable)responde error:(NSError* _Nullable)error;

-(void)task:(NSURLSessionDataTask * _Nullable)task withResponse:(id _Nullable)response;

-(void)task:(NSURLSessionDataTask * _Nullable)task withError:(id _Nullable)error;

-(void)progress:(NSProgress * _Nullable)uploadProgress;

@end
