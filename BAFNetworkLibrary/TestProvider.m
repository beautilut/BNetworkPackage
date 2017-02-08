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
    }
    return self;
}

-(id)parseResponde:(id)responde error:(NSError *)error
{
    NSLog(@"hahah");
    return responde;
}

@end
