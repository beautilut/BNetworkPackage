//
//  BBaseProvider.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "BBaseProvider.h"
#import "BProviderManager.h"
#import <objc/runtime.h>
#import "BAFRequestManager.h"

@implementation BFileObject

@end

@interface BBaseProvider()


@end

@implementation BBaseProvider


-(id)init
{
    if (self = [super init]) {
        self.httpMethod = HttpMethodPOST;
    }
    return self;
}

/**
 *  去除不需要封装的属性
 */
-(BOOL)shouleCodeWithPropertyName:(NSString*)propertyName
{
    if ([propertyName isEqualToString:@"successHandler"] ||
        [propertyName isEqualToString:@"progressHandler"] ||
        [propertyName isEqualToString:@"failureHandler"] ||
        [propertyName isEqualToString:@"method"] ||
        [propertyName isEqualToString:@"httpMethod"] ||
        [propertyName isEqualToString:@"images"] ||
        [propertyName isEqualToString:@"fileObject"]) {
        return NO;
    }
    return YES;
}

-(NSString*)basicUrlString
{
    return @"http://0.0.0.0:5000/";
}

-(NSString*)urlString
{
    return [NSString stringWithFormat:@"%@%@",[self basicUrlString] , self.method];
}

-(NSDictionary*)parameters
{
    NSMutableDictionary * props = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    for (unsigned int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        const char * char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([self shouleCodeWithPropertyName:propertyName]) {
            id propertyValue = [self valueForKey:(NSString*)propertyName];
            if (propertyValue)
                [props setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

@end


@implementation BBaseProvider (Send)

-(void)request
{
    [[BAFRequestManager manager] performSelectorOnMainThread:@selector(operateWithProvider:) withObject:self waitUntilDone:YES];
}

-(void)requestWithCompletionHandler:(CompeleteHandler)compeleteHandler
{
    self.compelteHandler = compeleteHandler;
    [self request];
}

-(void)requestWithResponseHandler:(ResponseHandler)responseHandler withCompeleteHandelr:(CompeleteHandler)compeleteHandler
{
    self.responseHandler = responseHandler;
    self.compelteHandler = compeleteHandler;
    [self request];
}

@end

@implementation BBaseProvider (Handle)

-(void)progress:(NSProgress *)uploadProgress
{
    
}

-(void)task:(NSURLSessionDataTask *)task withResponse:(id)response
{
    id  data = [self parseResponde:response error:task.error];
    
    self.compelteHandler(data , task.error);
    
}

-(void)task:(NSURLSessionDataTask *)task withError:(id)error
{
    
}

#pragma mark  --

-(id)parseResponde:(id)responde error:(NSError*)error
{
    if (self.responseHandler) {
       return self.responseHandler(responde , error);
    }
    return responde;
}

@end

