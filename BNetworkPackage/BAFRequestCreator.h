//
//  BAFRequestCreator.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 2017/2/16.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>
#import "BDefineTool.h"
#import "BProviderManagerDelgate.h"

@interface BAFRequestCreator : NSObject <BProviderManagerRequestDelgate>

@property (nonatomic , assign) id <BProviderManagerResponseDelegate> responseDelegate;
@property (nonatomic , assign) id <BProviderManagerProgressDelegate> progressDelegate;


@end
