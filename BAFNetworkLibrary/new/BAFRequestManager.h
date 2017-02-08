//
//  BAFRequestManager.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 2017/2/7.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "BBaseProvider.h"
#import "BDefineTool.h"

@interface BAFRequestManager : NSObject

+(BAFRequestManager*)manager;

-(NSObject*)operateWithProvider:(BBaseProvider*)provider;
@end
