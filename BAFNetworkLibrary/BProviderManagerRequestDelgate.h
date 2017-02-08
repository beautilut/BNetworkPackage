//
//  BProviderManagerRequestDelgate.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/9/2.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#define baseUrl @"http://www.baidu.com"

#import <Foundation/Foundation.h>

@protocol BProviderManagerResponseDelegate <NSObject>
@optional

-(void)requestStarted:(NSObject*)request;

-(void)requestFinished:(NSObject*)request;

-(void)requestFailed:(NSObject*)request error:(NSError*)error;

-(void)request:(NSObject*)request didReceiveResponseHeaders:(NSDictionary*)responseHeaders;


@end



@protocol BProviderManagerRequestDelgate <NSObject>

@property (nonatomic , assign) id <BProviderManagerResponseDelegate> responseDelegate;

@optional

/**
 *  msgmanager 发送调用请求
 *
 *  @return 返回创建的request
 */
-(NSObject*)operationWithProvider:(BBaseProvider*)provider
                    withUrlString:(NSString*)urlString
                       withParams:(NSDictionary*)paramsl;

/**
 *  获取当前响应的 status code
 *
 *  @return 响应代码号
 */
-(NSInteger)responseStatusCodeWithRequest:(NSObject*)request;

/**
 *  如果返回是字符串 则使用
 *
 *  @return 返回的字符串
 */
-(NSString*)responseStringWithRequest:(NSObject*)request;

/**
 *  如果返回的是data的 则使用
 *
 *  @return 返回的内容
 */
-(NSData*)responseDataWithRequest:(NSObject*)request;

/**
 * 取消某个请求
 *
 */
-(void)cancelRequest:(NSObject*)request;

@end

