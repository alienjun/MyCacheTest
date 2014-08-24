//
//  NetworkManager.m
//  MyFramework
//
//  Created by AlienJun on 14-8-9.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

#import "NetworkManager.h"
#import "MKNetworkKit.h"

@implementation NetworkManager

static NetworkManager *instance;
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance==nil) {
            instance=[[self alloc]init];
        }
    });
    return instance;
}


/**
 *  http post 请求
 *
 *  @param url   url
 *  @param block 回调block
 */
-(void)httpPost:(NSString *)url complete:(HttpComplete)callback
{
    [self httpPost:url dic:nil complete:callback];
}

/**
 *  post 带参数
 *
 *  @param url   url
 *  @param dic   参数
 *  @param block 回调block
 */
-(void)httpPost:(NSString *)url dic:(NSDictionary *)dic complete:(HttpComplete)callback
{
    MKNetworkEngine *networkEngine=[[MKNetworkEngine alloc] initWithHostName:HostName];
    MKNetworkOperation *op = [networkEngine operationWithURLString:url
                                                            params:dic
                                                        httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if (callback) {
            callback([completedOperation responseData],YES);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (callback) {
            callback(error,NO);
        }
    }];
    
    [networkEngine enqueueOperation:op];
}

/**
 *  http get请求
 *
 *  @param url   url
 *  @param block 回调block
 */
-(void)httpGet:(NSString *)url complete:(HttpComplete)callback
{
    [self httpGet:url dic:nil complete:callback];
}

/**
 *  get带参数请求
 *
 *  @param url   url
 *  @param dic   参数
 *  @param block 回调block
 */
-(void)httpGet:(NSString *)url dic:(NSDictionary *)dic complete:(HttpComplete)callback
{
    MKNetworkEngine *networkEngine=[[MKNetworkEngine alloc] initWithHostName:HostName];
    MKNetworkOperation *op = [networkEngine operationWithURLString:url
                                                            params:dic
                                                        httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if (callback) {
            callback([completedOperation responseData],YES);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (callback) {
            callback(error,NO);
        }
    }];
    
    [networkEngine enqueueOperation:op];
    
    
}





@end
