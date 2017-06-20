//
// Created by Beautilut on 2017/2/15.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import "BDownloadCache.h"

static NSMutableDictionary *cacheDictionary = nil;

@implementation BDownloadCache

+ (id)sharedCache {
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken , ^{
        cacheDictionary = [[NSMutableDictionary alloc] init];
    });

    BDownloadCache *shareCache = nil;

    @synchronized ( self ) {
        shareCache = [cacheDictionary objectForKey:NSStringFromClass ([self class])];

        if ( !shareCache ) {
            shareCache = [[[self class] alloc] init];
            [cacheDictionary setObject:shareCache forKey:NSStringFromClass ([self class])];
        }
    }

    return shareCache;
}

- (id)init {
    if ( self = [super init] ) {
        self.replaceDictionary = [NSMutableDictionary dictionaryWithDictionary:@{ @"sign": @"" , @"timestamp": @"" }];
    }
    return self;
}

- (NSString *)keyForURL:(NSURL *)url {

    NSString *urlString = [url absoluteString];

    if ( urlString.length == 0 ) {
        return nil;
    }

    if ( [[urlString substringFromIndex:( urlString.length - 1 )] isEqualToString:@"/"] ) {
        urlString = [urlString substringToIndex:urlString.length - 1];
    }

    /*去除 不需要的字段 在replacedictionary 中定义*/

    NSMutableString *mutableString = [NSMutableString stringWithString:urlString];

    for (NSString *key in [_replaceDictionary allKeys]) {
        [mutableString replaceOccurrencesOfString:[NSString stringWithFormat:@"%@=.*?&",key]
                                       withString:[_replaceDictionary objectForKey:key]
                                          options:NSRegularExpressionSearch
                                            range:NSMakeRange (0 , mutableString.length)];
    }


    // Borrowed from: http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
    const char *cStr = [mutableString UTF8String];
    unsigned char result[16];
    CC_MD5 (cStr , ( CC_LONG ) strlen (cStr) , result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X" , result[ 0 ] , result[ 1 ] , result[ 2 ] , result[ 3 ] , result[ 4 ] , result[ 5 ] , result[ 6 ] , result[ 7 ] , result[ 8 ] , result[ 9 ] , result[ 10 ] , result[ 11 ] , result[ 12 ] , result[ 13 ] , result[ 14 ] , result[ 15 ]];

}

@end