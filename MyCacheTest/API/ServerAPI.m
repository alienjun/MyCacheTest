//
//  ServerAPI.m
//  MyFramework
//
//  Created by AlienJun on 14-8-9.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

#import "ServerAPI.h"

#import "NetworkManager.h"

@implementation ServerAPI

static ServerAPI *instance;
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


-(void)httpGet:(NSString *)url refreshCached:(BOOL)refreshCache complete:(CompletionWithFinishedBlock)completedBlock
{
    [self httpGet:url refreshCached:refreshCache param:nil complete:completedBlock];
    
}

-(void)httpGet:(NSString *)url refreshCached:(BOOL)refreshCache param:(NSDictionary *)dic complete:(CompletionWithFinishedBlock)completedBlock
{
    if (refreshCache) {
        [self httpGetRefresh:url param:dic completedBlock:completedBlock];
    }
    else{
        CacheManager *cacheManger=[CacheManager sharedInstance];
        if ([cacheManger diskDataExistsForURL:[NSURL URLWithString:url]]) {
            [cacheManger getCache:url done:^(NSData *data, MyCacheType cacheType) {
                completedBlock(data, nil, cacheType, YES, url);
            }];
        }else{
            [self httpGetRefresh:url param:dic completedBlock:completedBlock];
        }
    }
}

-(void)httpPost:(NSString *)url refreshCached:(BOOL)refreshCache complete:(CompletionWithFinishedBlock)completedBlock
{
    [self httpPost:url refreshCached:refreshCache param:nil complete:completedBlock];
}

-(void)httpPost:(NSString *)url refreshCached:(BOOL)refreshCache param:(NSDictionary *)dic complete:(CompletionWithFinishedBlock)completedBlock
{
    if (refreshCache) {
        [self httpPostRefresh:url param:dic completedBlock:completedBlock];
    }
    else{
        CacheManager *cacheManger=[CacheManager sharedInstance];
        if ([cacheManger diskDataExistsForURL:[NSURL URLWithString:url]]) {
            [cacheManger getCache:url done:^(NSData *data, MyCacheType cacheType) {
                completedBlock(data, nil, cacheType, YES, url);
            }];
        }else{
            [self httpPostRefresh:url param:dic completedBlock:completedBlock];
        }
    }
}






/**
 *  get 请求并缓存
 *
 *  @param url            url
 *  @param dic            参数
 *  @param completedBlock 回调
 */
- (void)httpGetRefresh:(NSString *)url param:(NSDictionary *)dic completedBlock:(CompletionWithFinishedBlock)completedBlock
{
    [[NetworkManager sharedInstance] httpGet:url dic:dic complete:^(id responseObject, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功设置缓存
            [[CacheManager sharedInstance] saveDataToCache:responseObject forURL:[NSURL URLWithString:url]];
        }
        if (completedBlock) {
            completedBlock(responseObject, nil, MyCacheTypeNone, isSuccess, url);
            
        }
        
    }];
}

/**
 *  post 请求并缓存
 *
 *  @param url            url
 *  @param dic            参数
 *  @param completedBlock 回调
 */
- (void)httpPostRefresh:(NSString *)url param:(NSDictionary *)dic completedBlock:(CompletionWithFinishedBlock)completedBlock
{
    [[NetworkManager sharedInstance] httpPost:url dic:dic complete:^(id responseObject, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功设置缓存
            [[CacheManager sharedInstance] saveDataToCache:responseObject forURL:[NSURL URLWithString:url]];
        }
        if (completedBlock) {
            completedBlock(responseObject, nil, MyCacheTypeNone, isSuccess, url);
            
        }
        
    }];
}

@end
