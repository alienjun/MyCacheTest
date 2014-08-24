//
//  NetworkManager.h
//  MyFramework
//
//  Created by AlienJun on 14-8-9.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

/************上传文件类型****************/
#define MIME_Image_PNG       @"image/png"
#define MIME_Image_JPEG      @"image/jpeg"
#define MIME_Image_GIF       @"image/gif"
#define MIME_MPEG            @"video/mpeg"
#define MIME_ZIP             @"application/zip"
#define MIME_ALL             @"application/octet-stream"



#import "ServerAPI.h"

@interface NetworkManager : NSObject

+(instancetype)sharedInstance;

/**
 *  http post 请求
 *
 *  @param url   url
 *  @param block 回调block
 */
-(void)httpPost:(NSString *)url complete:(HttpComplete)callback;

/**
 *  post 带参数
 *
 *  @param url   url
 *  @param dic   参数
 *  @param block 回调block
 */
-(void)httpPost:(NSString *)url dic:(NSDictionary *)dic complete:(HttpComplete)callback;

/**
 *  http get请求
 *
 *  @param url   url
 *  @param block 回调block
 */
-(void)httpGet:(NSString *)url complete:(HttpComplete)callback;

/**
 *  get带参数请求
 *
 *  @param url   url
 *  @param dic   参数
 *  @param block 回调block
 */
-(void)httpGet:(NSString *)url dic:(NSDictionary *)dic complete:(HttpComplete)callback;



@end
