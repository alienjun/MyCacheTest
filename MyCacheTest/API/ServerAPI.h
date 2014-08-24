//
//  ServerAPI.h
//  MyFramework
//
//  Created by AlienJun on 14-8-9.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//
#import "CacheManager.h"

//请求类型
typedef enum : NSUInteger {
    GET,
    POST
} ActionType;


//请求完成执行的block
typedef void (^HttpComplete)(id responseObject,BOOL isSuccess);
//文件上传和下载进度
typedef void (^HandleProgress) (double progress);

@interface ServerAPI : NSObject

+(instancetype)sharedInstance;



/**
 *  httpget请求
 *
 *  @param url            url
 *  @param refreshCache   是否刷新缓存
 *  @param completedBlock 完成回调
 */
-(void)httpGet:(NSString *)url refreshCached:(BOOL)refreshCache complete:(CompletionWithFinishedBlock)completedBlock;
-(void)httpGet:(NSString *)url refreshCached:(BOOL)refreshCache param:(NSDictionary *)dic complete:(CompletionWithFinishedBlock)completedBlock;

/**
 *  httppost请求
 *
 *  @param url            url
 *  @param refreshCache   是否刷新缓存
 *  @param completedBlock 完成回调
 */
-(void)httpPost:(NSString *)url refreshCached:(BOOL)refreshCache complete:(CompletionWithFinishedBlock)completedBlock;
-(void)httpPost:(NSString *)url refreshCached:(BOOL)refreshCache param:(NSDictionary *)dic complete:(CompletionWithFinishedBlock)completedBlock;

@end
