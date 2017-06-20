//
//  BProviderManagerRequestDelgate.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/9/2.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#define baseUrl @"http://www.baidu.com"

#import <Foundation/Foundation.h>
#import "BBaseProvider.h"


@protocol BProviderManagerResponseDelegate <NSObject>
@optional

-(void)task:(NSURLSessionDataTask*)task withResponse:(id)response;

-(void)task:(NSURLSessionDataTask*)task withError:(id)error;

-(void)provider:(BBaseProvider*)provider withProgress:(NSProgress*)progress;


@end

@protocol  BProviderManagerProgressDelegate <NSObject>

@optional


@end


@protocol BProviderManagerRequestDelgate <NSObject>

@property (nonatomic , assign) id <BProviderManagerResponseDelegate> responseDelegate;
@property (nonatomic , assign) id <BProviderManagerProgressDelegate> progressDelegate;

@optional



-(NSObject*)operateWithProvider:(BBaseProvider*)provider;


-(void)cancelRequest:(NSObject*)request;

@end

