
//  BAFRequestManager.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 2017/2/7.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import "BAFRequestManager.h"
#import "BAFRequestCreator.h"



@interface BAFRequestManager () <BProviderManagerProgressDelegate , BProviderManagerResponseDelegate>

@property (nonatomic , readonly) NSMutableDictionary * recordCacheDictionary;
@property (nonatomic , readonly) NSMutableArray * providerArray;

@end


@implementation BAFRequestManager

+(BAFRequestManager*)manager
{
    static dispatch_once_t onceToken;
    static BAFRequestManager * defaultManager = nil;
    dispatch_once(&onceToken, ^{
        defaultManager = [[BAFRequestManager alloc] init];
    });
    return defaultManager;
}

-(id<BProviderManagerRequestDelgate>)creator
{
    @synchronized (self) {
        
        if(!_creator) {
            _creator = [[BAFRequestCreator alloc] init];
            
            _creator.responseDelegate = self;
            _creator.progressDelegate = self;
        }
        
    }
    return _creator;
}

-(id)init {
    if(self = [super init]) {
        _providerArray = [[NSMutableArray alloc] init];
        _recordCacheDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark  - cancel provider -

-(void)doCancelAndNotification:(BBaseProvider *)provider
{
    provider.sendStatus = EBProviderStatusIdle;
    [self.creator cancelRequest:provider.operation];
    provider.operation = nil;

    __block typeof(self) wself = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError * error = [NSError errorWithDomain:BHTTPRequestErrorDomain
                                              code:BNetworkErrorCancelled
                                          userInfo:@{NSLocalizedDescriptionKey : @"请求已被取消"}];
        BProviderResultPackage * package = [wself packageWithResult:nil error:error];
        [wself provider:provider responedComplete:package];
    });
}

-(void)cancelAllProvider
{
    BBaseProvider * tmpProvider;
    @synchronized (self) {
        for (tmpProvider in _providerArray) {
            [self doCancelAndNotification:tmpProvider];
        }
        if ( [_providerArray count] > 0){
            [_providerArray removeAllObjects];
        }
    }
}

-(void)cancelProviderInArray:(NSArray*)providers
{
    @synchronized (self) {
        for (BBaseProvider * tmpProvider in providers) {
            [self cancelProvider:tmpProvider];
        }
    }
}

-(void)cancelProvider:(BBaseProvider *)provider
{
    NSMutableArray * removes = [[NSMutableArray alloc] init];
    BBaseProvider * tmpProvider;
    @synchronized (self) {
        for (tmpProvider in _providerArray) {
            if (tmpProvider == provider) {
                [self doCancelAndNotification:tmpProvider];
                [removes addObject:tmpProvider];
            }
        }

        if ( [removes count] > 0) {
            [_providerArray removeObjectsInArray:removes];
        }
    }
}

-(void)cancelProviderBySender:(id)sender
{
    NSMutableArray * removes = [[NSMutableArray alloc] init];
    BBaseProvider * tmpProvider ;
    @synchronized (self) {
        for (tmpProvider in _providerArray) {
            if (sender == tmpProvider.sender) {
                [self doCancelAndNotification:tmpProvider];
                [removes addObject:tmpProvider];
            }
        }

        if ( [removes count] > 0) {
            [_providerArray removeObjectsInArray:removes];
        }
    }
}

-(BProviderResultPackage *)packageWithResult:(id)result error:(NSError*)error
{
    BProviderResultPackage * package = [[BProviderResultPackage alloc] init];
    package.providerResult = result;
    package.providerError = error;
    package.isUseCache = NO;
    return package;
}

#pragma mark - find provider -
-(NSArray *)allProviders
{
    @synchronized (self) {
        return _providerArray;
    }
}

-(NSArray *)getProviderByBlock:(SelectBlock )selectBlock
{
    NSMutableArray * providers = [[NSMutableArray alloc] init];
    @synchronized (self) {
        if (selectBlock) {
            BBaseProvider * tmpProvider;
            for(tmpProvider in _providerArray){
                if (selectBlock(tmpProvider)){
                    [providers addObject:tmpProvider];
                }
            }
        }
    }
    return providers;
}

-(NSArray*)getProvidersBySender:(id)sender
{
    NSMutableArray * providers = [[NSMutableArray alloc] init];
    BBaseProvider * tmpProvider;
    @synchronized (self) {
        for (tmpProvider in _providerArray) {
            if(sender == tmpProvider.sender) {
                [providers addObject:tmpProvider];
            }
        }
    }
    return providers;
}

-(NSArray *)getProvidersByClass:(Class)providerClass
{
    NSMutableArray * providers = [[NSMutableArray alloc] init];
    BBaseProvider * tmpProvider;
    @synchronized (self) {
        for(tmpProvider in _providerArray) {
            if ( [tmpProvider isKindOfClass:providerClass] ){
                [providers addObject:tmpProvider];
            }
        }
    }
    return providers;
}

-(NSArray *)getProvidersByOperation:(NSObject *)operation
{
    NSMutableArray *providers = [[NSMutableArray alloc] init];
    BBaseProvider * tmpProvider;
    @synchronized (self) {
        for (tmpProvider in _providerArray) {
            if (operation == tmpProvider.operation) {
                [providers addObject:tmpProvider];
            }
        }
    }
    return providers;
}

#pragma mark - sender -
-(void)sendProvider:(BBaseProvider *)provider
{
    [provider cancelProvider];

    @synchronized (self) {
        [_providerArray addObject:provider];
    }

    id<NSCoding> cacheObject = nil;
    if(provider.cache && (provider.cache.cachePolicy == EBCachePolicyCacheAlwaysRead || provider.cache.cachePolicy == EBCachePolicyCacheFirst))
    {
        NSError * error = nil;
        cacheObject = [provider readLocalCacheWithError:error];
        if (error && (EBCachePolicyCacheFirst == provider.cache.cachePolicy)) {
            cacheObject = nil;
        }
    }

    if (!cacheObject) {
        [self.creator operateWithProvider:provider];
    }else {
        [provider task:nil withResponse:cacheObject];
    }
}

#pragma mark  -- response Handler -
-(void)provider:(BBaseProvider *)provider withProgress:(NSProgress *)progress
{
    
}

-(void)task:(NSURLSessionDataTask *)task withError:(id)error
{
    
}

-(void)task:(NSURLSessionDataTask *)task withResponse:(id)response
{
    BBaseProvider * provider = [[self getProvidersByOperation:task] firstObject];

    @synchronized (self) {
        [_providerArray removeObject:provider];
    }

    [provider saveLocalCache:response];

    [provider task:task withResponse:response];
}

#pragma mark  - msg handler -



-(void)provider:(BBaseProvider *)provider responedComplete:(BProviderResultPackage *)bProviderResultPackage
{

}

@end
