//
//  BBaseProvider.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "BBaseProvider.h"
#import <objc/runtime.h>
#import "BAFRequestManager.h"
#import "BDownloadCache.h"
#import "BLocalCache.h"

@implementation BFileObject

@end

@interface BBaseProvider ()


@end

@implementation BBaseProvider


- (id)init {
    if ( self = [super init] ) {
        self.httpMethod = HttpMethodPOST;
    }
    return self;
}

/**
 *  去除不需要封装的属性
 */
- (BOOL)shouleCodeWithPropertyName:(NSString *)propertyName {
    return !( [propertyName isEqualToString:@"compelteHandler"] ||
        [propertyName isEqualToString:@"responseHandler"] ||
        [propertyName isEqualToString:@"receiveHandler"] ||
        [propertyName isEqualToString:@"method"] ||
        [propertyName isEqualToString:@"httpMethod"] ||
        [propertyName isEqualToString:@"images"] ||
        [propertyName isEqualToString:@"fileObject"] );
}

- (NSString *)basicUrlString {
    return @"http://0.0.0.0:5000/";
}

- (NSString *)urlString {
    return [NSString stringWithFormat:@"%@%@" , [self basicUrlString] , self.method];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList ([self class] , &outCount);

    for ( unsigned int i = 0 ; i < outCount ; i ++ ) {
        objc_property_t property = properties[ i ];
        const char *char_f = property_getName (property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ( [self shouleCodeWithPropertyName:propertyName] ) {
            id propertyValue = [self valueForKey:( NSString * ) propertyName];
            if ( propertyValue )
                [props setValue:propertyValue forKey:propertyName];
        }
    }
    free (properties);
    return props;
}

@end


@implementation BBaseProvider (Send)

- (void)request {
    [[BAFRequestManager manager] performSelectorOnMainThread:@selector (sendProvider:) withObject:self waitUntilDone:YES];
}

- (void)requestWithCompletionHandler:(CompeleteHandler)compeleteHandler {
    self.compelteHandler = compeleteHandler;
    [self request];
}

- (void)requestWithResponseHandler:(ResponseHandler)responseHandler withCompeleteHandelr:(CompeleteHandler)compeleteHandler {
    self.responseHandler = responseHandler;
    self.compelteHandler = compeleteHandler;
    [self request];
}

@end

@implementation BBaseProvider (Handle)

- (void)progress:(NSProgress *)uploadProgress {

}

- (void)task:(NSURLSessionDataTask *)task withResponse:(id)response {
    id data = [self parseResponde:response error:task.error];

    self.compelteHandler (data , task.error);

}

- (void)task:(NSURLSessionDataTask *)task withError:(id)error {

}

#pragma mark  --

- (id)parseResponde:(id)responde error:(NSError *)error {
    if ( self.responseHandler ) {
        return self.responseHandler (responde , error);
    }
    return responde;
}

@end

@implementation BBaseProvider (Cache)

-(void)useCacheInfo:(BOOL)useCache
{
    if (useCache) {
        [self useDownloadCache:[BDownloadCache sharedCache] cacheSecond:10 * 60];
    }else {
        _cache = nil;
    }

}

-(void)useDownloadCache:(BDownloadCache *)downloadCache
            cacheSecond:(NSTimeInterval)cacheSecond
{
    [self useDownloadCache:downloadCache
               cacheSecond:cacheSecond
               cachePolicy:EBCachePolicyCacheFirst];
}

-(void)useDownloadCache:(BDownloadCache *)downloadCache
            cacheSecond:(NSTimeInterval)cacheSecond
            cachePolicy:(EBCachePolicy)cachePolicy
{
    if(!_cache){
        _cache = [[BCacheInfo alloc] init];
    }
    _cache.cachePolicy = cachePolicy;
    _cache.cacheSecond = cacheSecond;
    _cache.downloadCache = downloadCache;
}

-(void)readLocalCacheWithCompletion:(ReadCacheCompletion)completion
{
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT , 0) , ^{
        NSError *error = nil;
        id<NSCoding> cacheData = [self readLocalCacheWithError:error];
        dispatch_async (dispatch_get_main_queue () , ^{
            if(completion){
                completion(cacheData , error);
            }
        });
    });
}

-(void)saveLocalCache:(id<NSCoding>)cacheObject completion:(SaveCacheCompletion)completion
{
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT , 0) , ^{
        BOOL success = [self saveLocalCache:cacheObject];
        dispatch_async (dispatch_get_main_queue () , ^{
           if(completion){
               completion(success);
           }
        });
    });
}

- (id <NSCoding>)readLocalCache {
    return [self readLocalCacheWithError:nil];
}

- (id <NSCoding>)readLocalCacheWithError:(NSError *)pError {

    if(!_cache){
        return nil;
    }

    if (!self.cache.downloadCache)
    {
        self.cache.downloadCache = [BDownloadCache sharedCache];
    }

    NSString *urlStr = [self urlString];
    NSString * keyStr = [self.cache.downloadCache keyForURL:[NSURL URLWithString:urlStr]];

    BLocalCache * localCache = [BLocalCache currentCache];

    id<NSCoding> cacheData = [localCache objectForKey:keyStr];
    BOOL expired = YES;
    if(expired) {

        if(pError){
            pError = [NSError errorWithDomain:BRNormalErrorDomain
                                          code:EBReadCacheErrorCodeCacheExpired
                                      userInfo:@{NSLocalizedDescriptionKey : @"缓存过期"}];
        }else {

            if (!cacheData && pError) {
                pError = [NSError errorWithDomain:BRNormalErrorDomain
                                              code:EBReadCacheErrorCodeCacheEmpty
                                          userInfo:@{NSLocalizedDescriptionKey : @"无缓存"}];
            }

        }

    }

    return cacheData;
}

-(BOOL)saveLocalCache:(id <NSCoding>)cacheObject {

    if(!_cache) {
        return NO;
    }

    if(!self.cache.downloadCache){
        self.cache.downloadCache = [BDownloadCache sharedCache];
    }

    NSString * urlStr = [self urlString];
    NSString * keyStr = [self.cache.downloadCache keyForURL:[NSURL URLWithString:urlStr]];

    BLocalCache * localCache = [BLocalCache currentCache];
    [localCache setObject:cacheObject
                   forKey:keyStr
      withTimeoutInterval:self.cache.cacheSecond];

    return YES;
}

-(void)clearLocalCache {
    if(!_cache) {
        return;
    }

    if(!self.cache.downloadCache) {
        self.cache.downloadCache = [BDownloadCache sharedCache];
    }

    NSString *urlStr = [self urlString];
    NSString *keyStr = [self.cache.downloadCache keyForURL:[NSURL URLWithString:urlStr]];

    BLocalCache * localCache = [BLocalCache currentCache];
    [localCache removeCacheForKey:keyStr];
}

//-(NSString *)urlEncodeWithCacheUrl:(BOOL)useCacheUrl
//{
//
//}

@end

@implementation BBaseProvider (cancel)

-(void)cancelProvider {

    [[BAFRequestManager manager] cancelProvider:self];
}

@end
