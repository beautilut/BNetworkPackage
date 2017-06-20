//
//  BAFRequestManager.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 2017/2/7.
//  Copyright © 2017年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BProviderManagerDelgate.h"

typedef BOOL (^SelectBlock)(BBaseProvider * provider);


@interface BAFRequestManager : NSObject

@property (nonatomic , strong) id <BProviderManagerRequestDelgate> creator;

+(BAFRequestManager*)manager;

-(void)sendProvider:(BBaseProvider*)provider;


#pragma  mark 取消

-(void)cancelAllProvider;

-(void)cancelProviderInArray:(NSArray*)providers;

-(void)cancelProvider:(BBaseProvider *)provider;

-(void)cancelProviderBySender:(id)sender;

#pragma mark  寻找请求

-(NSArray *)allProviders;

-(NSArray *)getProviderByBlock:(SelectBlock )selectBlock;

-(NSArray*)getProvidersBySender:(id)sender;

-(NSArray *)getProvidersByClass:(Class)providerClass;

-(NSArray *)getProvidersByOperation:(NSObject *)operation;



@end
