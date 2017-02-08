//
//  BAFMsgCreator.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/9/2.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "BBaseProvider.h"
#import "BProviderManagerRequestDelgate.h"

#import "BDefineTool.h"

@interface BAFMsgCreator : NSObject <BProviderManagerRequestDelgate>

@property (nonatomic , assign) id <BProviderManagerResponseDelegate> responseDelegate;

@end
