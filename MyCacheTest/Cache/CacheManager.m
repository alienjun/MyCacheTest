//
//  CacheManager.m
//  MyFramework
//
//  Created by AlienJun on 14-8-9.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

static id instance;
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance==nil) {
            instance=[self new];
        }
    });
    return instance;
}


- (id)init {
    if ((self = [super init])) {
        _myCache = [self createCache];
    }
    return self;
}

- (Cache *)createCache {
    return [Cache sharedInstance];
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (self.cacheKeyFilter) {
        return self.cacheKeyFilter(url);
    }
    else {
        return [url absoluteString];
    }
}

- (BOOL)cachedDataExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    if ([self.myCache dataFromMemoryCacheForKey:key] != nil) return YES;
    return [self.myCache diskDataExistsWithKey:key];
}

- (BOOL)diskDataExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return [self.myCache diskDataExistsWithKey:key];
}

- (void)cachedDataExistsForURL:(NSURL *)url
                     completion:(CheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    BOOL isInMemoryCache = ([self.myCache dataFromMemoryCacheForKey:key] != nil);
    
    if (isInMemoryCache) {
        // making sure we call the completion block on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(YES);
            }
        });
        return;
    }
    
    [self.myCache diskDataExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // the completion block of checkDiskCacheForImageWithKey:completion: is always called on the main queue, no need to further dispatch
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}

- (void)diskDataExistsForURL:(NSURL *)url
                   completion:(CheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    [self.myCache diskDataExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // the completion block of checkDiskCacheForImageWithKey:completion: is always called on the main queue, no need to further dispatch
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}



- (void)saveDataToCache:(NSData *)data forURL:(NSURL *)url
{
    if (data && url) {
        NSString *key = [self cacheKeyForURL:url];
        [self.myCache storeData:data forKey:key toDisk:YES];
    }
}



//获取缓存
-(NSData *) getCache:(NSString *)key
{
    if (key) {
        return [self.myCache dataFromDiskCacheForKey:key];
    }
    return nil;
}

-(void) getCache:(NSString *)key done:(QueryCompletedBlock)doneBlock
{
    if (key) {
        [self.myCache queryDiskCacheForKey:key done:^(NSData *data, MyCacheType cacheType) {
            if (data) {
                doneBlock((NSData*)data,cacheType);
            }else{
                doneBlock(nil,cacheType);
            }
        }];
    }
}


//设置缓存
-(void) setCache: (NSData *)data key:(NSString *)key
{
    if (data && key) {
        NSString *key_str = [self cacheKeyForURL:[NSURL URLWithString:key]];
        [self.myCache storeData:data forKey:key_str toDisk:NO];
    }
}


@end
