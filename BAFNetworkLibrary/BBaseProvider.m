//
//  BBaseProvider.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "BBaseProvider.h"
#import <objc/runtime.h>

@interface BBaseProvider()

@end

@implementation BBaseProvider


/**
 *  去除不需要封装的属性
 */
-(BOOL)shouleCodeWithPropertyName:(NSString*)propertyName
{
    if ([propertyName isEqualToString:@"responseHandler"] ||
        [propertyName isEqualToString:@"completeHandler"] ) {
        return NO;
    }
    return YES;
}

-(NSString*)urlString
{
    return self.method;
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
