//
// Created by Beautilut on 2017/2/15.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface BDownloadCache : NSObject

@property (nonatomic , retain) NSMutableDictionary *replaceDictionary;

+(id)sharedCache;
-(NSString *)keyForURL:(NSURL *)url;

@end
