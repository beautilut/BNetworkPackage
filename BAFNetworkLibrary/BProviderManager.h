//
//  BProviderManager.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBaseProvider.h"
#import "BProviderManagerRequestDelgate.h"

@interface BProviderManager : NSObject

@property (nonatomic , strong) id <BProviderManagerRequestDelgate> creator;

+(BProviderManager*)instance;

-(void)sendProvider:(BBaseProvider*)provider;

@end
