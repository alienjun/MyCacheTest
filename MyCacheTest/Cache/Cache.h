//
//  Cache.h
//  MyFramework
//
//  Created by AlienJun on 14-8-17.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MyCacheType) {
    /**
     * 不从缓存获取，直接网络获取
     */
    MyCacheTypeNone,
    /**
     * 从磁盘获取
     */
    MyCacheTypeDisk,
    /**
     * 从内存获取
     */
    MyCacheTypeMemory
};

typedef void(^QueryCompletedBlock)(NSData *data, MyCacheType cacheType);

typedef void(^CheckCacheCompletionBlock)(BOOL isInCache);

typedef void(^CalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

typedef void(^NoParamsBlock)();

@interface Cache : NSObject

/**
 * 内存最大缓存数量
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 *  最大缓存时间
 */
@property (assign, nonatomic) NSInteger maxCacheAge;
/**
 *  最大缓存大小
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

/**
 *  全局缓存实例
 *
 *  @return 实例
 */
+(instancetype) sharedInstance;

/**
 *  初始化一个新的缓存存储与特定的命名空间
 *
 *  @param ns 命名空间
 *
 *  @return
 */
- (id)initWithNamespace:(NSString *)ns;

/**
 *  存储数据到内存和磁盘
 *
 *  @param data 数据
 *  @param key  key
 */
- (void)storeData:(NSData *)data forKey:(NSString *)key;

/**
 *  缓存数据到内存，可选磁盘缓存
 *
 *  @param data   数据
 *  @param key    key
 *  @param toDisk 可选缓存到磁盘
 */
- (void)storeData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk;


/**
 *  异步查询磁盘缓存
 *
 *  @param key       key
 *  @param doneBlock 完成后回调
 *
 *  @return 当前操作
 */
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(QueryCompletedBlock)doneBlock;

/**
 *  同步查询缓存,仅查询内存
 *
 *  @param key key
 *
 *  @return 查询到的数据
 */
- (NSData *)dataFromMemoryCacheForKey:(NSString *)key;

/**
 *  先检查内存，如果没有则查询磁盘。同步查询
 *
 *  @param key key
 *
 *  @return 查询到的数据
 */
- (NSData *)dataFromDiskCacheForKey:(NSString *)key;


/**
 *  移除内存和磁盘缓存
 *
 *  @param key        key
 *  @param completion 完成后执行block
 */
- (void)removeDataForKey:(NSString *)key withCompletion:(NoParamsBlock)completion;
- (void)removeDataForKey:(NSString *)key;

/**
 *  移除内存缓存，可选移除磁盘缓存
 *
 *  @param key        key
 *  @param fromDisk   可选移除磁盘缓存
 *  @param completion 完成后执行block
 */
- (void)removeDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(NoParamsBlock)completion;
- (void)removeDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk;

/**
 *  清空在内存中的缓存
 */
- (void)clearMemory;

/**
 *  清空所有磁盘缓存
 *
 *  @param completion 完成后执行block
 */
- (void)clearDiskOnCompletion:(NoParamsBlock)completion;
- (void)clearDisk;

/**
 *  清除磁盘中过期的缓存
 *
 *  @param completionBlock 完成后执行block
 */
- (void)cleanDiskWithCompletionBlock:(NoParamsBlock)completionBlock;
- (void)cleanDisk;

/**
 *  获取磁盘缓存大小
 *
 */
- (NSUInteger)getSize;

/**
 * 获取磁盘缓存个数
 */
- (NSUInteger)getDiskCount;

/**
 * 异步计算磁盘缓存大小
 */
- (void)calculateSizeWithCompletionBlock:(CalculateSizeBlock)completionBlock;
/**
 *  已经检查是否已经在磁盘上存在缓存
 *
 *  @param key             key
 *  @param completionBlock 完成后执行block
 */
- (void)diskDataExistsWithKey:(NSString *)key completion:(CheckCacheCompletionBlock)completionBlock;
- (BOOL)diskDataExistsWithKey:(NSString *)key;

/**
 *  获取缓存路径
 *
 *  @param key  url的编码
 *  @param path 缓存的根路径
 *
 *  @return 完整的缓存路径
 */
- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;

/**
 *  默认的缓存路径
 *
 *  @param key url的编码
 *
 *  @return 缓存路径
 */
- (NSString *)defaultCachePathForKey:(NSString *)key;


@end
