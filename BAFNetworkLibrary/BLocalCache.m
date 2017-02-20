//
// Created by Beautilut on 2017/2/14.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import "BLocalCache.h"

#define SubNameForCache @"providerCache"

static BLocalCache * _instance;
@implementation BLocalCache

+(BLocalCache *)currentCache {

    NSFileManager * pFileManager = [NSFileManager defaultManager];
    NSURL *containerURL = nil;

    if ( 0 && [pFileManager respondsToSelector:@selector(containerURLForSecurityApplicationGroupIdentifier:)]) {
        containerURL = [pFileManager containerURLForSecurityApplicationGroupIdentifier:SubNameForCache];
        containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
    }else {
        NSArray * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        containerURL = [NSURL fileURLWithPath:[cachePath firstObject]];
    }
    
    

    return [BLocalCache currentCacheForPath:containerURL.path];
}

+(BLocalCache *)currentCacheForPath:(NSString *)cachePath {

    @synchronized (self) {

        if (!_instance){
            _instance = [[BLocalCache alloc] initWithCacheDirectory:cachePath];
            _instance.defaultTimeoutInterval = 86400;
        }
    }
    return _instance;
}

@end
