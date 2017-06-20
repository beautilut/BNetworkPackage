//
//  TestProvider.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "TestProvider.h"

@implementation TestProvider

-(id)init
{
    if (self = [super init]) {
        self.method = @"test";
        [self useCacheInfo:YES];
    }
    return self;
}

-(id)parseResponde:(id)responde error:(NSError *)error
{
//    NSDictionary * dic = responde;
    
    return @{@"123":@"321"};
}

@end
