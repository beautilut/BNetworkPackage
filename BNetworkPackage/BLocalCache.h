//
// Created by Beautilut on 2017/2/14.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import <EGOCache/EGOCache.h>

@interface BLocalCache : EGOCache

+(BLocalCache *)currentCache;

+(BLocalCache *)currentCacheForPath:(NSString *)cachePath;

-(BOOL)cacheIsExpiredWithKey:(NSString*)key;

@end
