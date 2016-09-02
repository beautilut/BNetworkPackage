//
//  BProviderManager.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#define baseUrl @"http://www.baidu.com"


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BBaseProvider.h"


@interface BProviderManager : NSObject

-(void)sendProvider:(BBaseProvider*)provider;

@end
