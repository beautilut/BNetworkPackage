//
// Created by Beautilut on 2017/2/17.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BProviderResultPackage : NSObject

@property (nonatomic , strong) id providerResult;
@property (nonatomic , strong) NSError * providerError;
@property (nonatomic , assign) BOOL isUseCache;

@end