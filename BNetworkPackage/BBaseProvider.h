///
//  BBaseProvider.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCacheInfo.h"
#import "BNetworkSetting.h"
#import "BProviderResultPackage.h"

typedef void (^DidReceiveHandler) (long long bytes , long long totalBytes);
typedef void (^CompeleteHandler) (id _Nullable response , NSError *_Nullable error);
typedef id _Nonnull (^ResponseHandler) (id _Nullable response , NSError *_Nullable error);
typedef void(^ReadCacheCompletion)(id<NSCoding> _Nullable cache , NSError * _Nullable error);
typedef void(^SaveCacheCompletion)(BOOL success);
typedef NSDictionary * _Nullable(^ReplacePropertyValue)();

static NSString *const _Nullable HttpMethodGET = @"GET";
static NSString *const _Nullable HttpMethodPOST = @"POST";


@interface BFileObject : NSObject

@property(nonatomic , strong) NSData *_Nullable fileData;

@property(nonatomic , strong) NSString *_Nullable fileName;

@property(nonatomic , strong) NSString *_Nullable name;

@property(nonatomic , strong) NSString *_Nullable type;

@end

@protocol BBaseProviderDelegate <NSObject>

@end


@interface BBaseProvider : NSObject

//持有状态
@property(nonatomic , weak) NSObject *operation; //创建请求的 operation ， AF为NSURLSessionDataTask
@property(nonatomic , assign) EBProviderPriority requestPriority; //请求优先级
@property(nonatomic , assign) EBProviderStatus sendStatus; //发送状态
@property(nonatomic , weak) id sender; //发送对象

//请求设置
@property(nonatomic , strong) NSString *_Nullable method; //请求具体方法
@property(nonatomic , strong) NSString *_Nullable httpMethod; //请求类型



//数据处理block
@property(nonatomic , copy) _Nullable CompeleteHandler compelteHandler; //完成的处理block
@property(nonatomic , copy) _Nullable ResponseHandler responseHandler; //解析处理block
@property(nonatomic , copy) _Nullable DidReceiveHandler receiveHandler; //获取处理block


//上传数据
@property(nonatomic , strong) NSArray *_Nullable images; //需要上传的图片
@property(nonatomic , strong) BFileObject *_Nullable fileObject; //文件数据、


//缓存
@property(nonatomic , strong) BCacheInfo * _Nullable cache; //保存的缓存
@property (nonatomic , strong) BProviderResultPackage * resultPackage; //返回的数据
@property (nonatomic , readonly) BOOL isUsedCacheData ; //是否使用了缓存数据


- (NSString *_Nullable)urlString;

- (NSDictionary *_Nullable)parameters;

@end

@interface BBaseProvider (Send)

- (void)request;

- (void)requestWithCompletionHandler:(CompeleteHandler _Nullable)compeleteHandler;

- (void)requestWithResponseHandler:(ResponseHandler _Nullable)responseHandler
              withCompeleteHandelr:(CompeleteHandler _Nullable)compeleteHandler;

@end

@interface BBaseProvider (Handle)

- (id _Nullable)parseResponde:(id _Nullable)responde error:(NSError *_Nullable)error;

- (void)task:(NSURLSessionDataTask *_Nullable)task withResponse:(id _Nullable)response;

- (void)task:(NSURLSessionDataTask *_Nullable)task withError:(id _Nullable)error;

- (void)progress:(NSProgress *_Nullable)uploadProgress;

@end

@interface BBaseProvider (Cache)

-(void)useCacheInfo:(BOOL)useCache;

-(void)useDownloadCache:(BDownloadCache *)downloadCache
            cacheSecond:(NSTimeInterval)cacheSecond;

-(void)useDownloadCache:(BDownloadCache *)downloadCache
            cacheSecond:(NSTimeInterval)cacheSecond
            cachePolicy:(EBCachePolicy)cachePolicy;

-(void)readLocalCacheWithCompletion:(ReadCacheCompletion)completion;

-(void)saveLocalCache:(id<NSCoding>)cacheObject completion:(SaveCacheCompletion)completion;

- (id <NSCoding> _Nullable)readLocalCache;

- (id <NSCoding> _Nullable)readLocalCacheWithError:(NSError * _Nullable)pError;

- (BOOL)saveLocalCache:(id <NSCoding> _Nullable)cacheObject;

- (void)clearLocalCache;

@end

@interface BBaseProvider (cancel)

-(void)cancelProvider;

@end