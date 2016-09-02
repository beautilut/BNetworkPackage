///
//  BBaseProvider.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/14.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef id(^ResponseHandler)(id response , NSError **error);
typedef void (^CompleteHandler)(id response , NSError *error);

static NSString* const HttpMethodGET = @"GET";
static NSString* const HttpMethodPOST = @"POST";



@interface BBaseProvider : NSObject

//不需要加进传参的属性

@property (nonatomic , copy) ResponseHandler responseHandler; //返回的函数处理

@property (nonatomic , copy) CompleteHandler completeHandler; //返回完成的处理



@property (nonatomic, strong) NSString * method; //请求具体方法

@property (nonatomic, strong) NSString * httpMethod; //请求类型




-(NSString*)urlString;

-(void)requestWithResponserHandler:(ResponseHandler)responserHandler completionHandler:(CompleteHandler)completionHnadler;

-(NSDictionary*)parameters;

@end
