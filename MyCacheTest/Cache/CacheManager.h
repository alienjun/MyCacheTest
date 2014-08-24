//
//  CacheManager.h
//  MyFramework
//
//  Created by AlienJun on 14-8-9.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"


typedef NSString *(^DataCacheKeyFilterBlock)(NSURL *url);
typedef void(^CompletionWithFinishedBlock)(NSData *data, NSError *error, MyCacheType cacheType, BOOL finished, NSString *url);


@interface CacheManager : NSObject

@property (strong, nonatomic, readonly) Cache *myCache;
@property (copy) DataCacheKeyFilterBlock cacheKeyFilter;

+(instancetype)sharedInstance;

/**
 *  先检查内存，如果没有则查询磁盘。
 *
 *  @param key key
 *
 *  @return nsdata
 */
-(NSData *) getCache:(NSString *)key;

-(void)  getCache:(NSString *)key done:(QueryCompletedBlock)doneBlock;

/**
 *  缓存数据到内存,不缓存到磁盘
 *
 *  @param data 需要缓存的数据
 *  @param key  key
 *
 */
-(void) setCache: (NSData *)data key:(NSString *)key;





/**
 *  保存数据到内存，磁盘
 *
 *  @param data data
 *  @param url   url
 */
- (void)saveDataToCache:(NSData *)data forURL:(NSURL *)url;

/**
 *  检查数据是否被缓存,先检查内存，如果不存在再查询磁盘
 *
 *  @param url url
 *
 *  @return 是否缓存
 */
- (BOOL)cachedDataExistsForURL:(NSURL *)url;

/**
 *  磁盘是否缓存
 *
 *  @param url url
 *
 *  @return 是否缓存
 */
- (BOOL)diskDataExistsForURL:(NSURL *)url;

/**
 *  异步检查数据是否缓存,先检查内存，如果不存在再查询磁盘
 *
 *  @param url             url
 *  @param completionBlock 回调block
 */
- (void)cachedDataExistsForURL:(NSURL *)url
                     completion:(CheckCacheCompletionBlock)completionBlock;

/**
 *  异步检查数据是否缓存在磁盘上
 *
 *  @param url             url
 *  @param completionBlock 回调block
 */
- (void)diskDataExistsForURL:(NSURL *)url
                   completion:(CheckCacheCompletionBlock)completionBlock;


/**
 *Return the cache key for a given URL
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;



@end
