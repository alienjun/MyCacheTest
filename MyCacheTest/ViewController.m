//
//  ViewController.m
//  MyCacheTest
//
//  Created by AlienJun on 14-8-24.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//

#import "ViewController.h"
#import "ServerAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[ServerAPI sharedInstance] httpGet:URL_test refreshCached:NO complete:^(NSData *data, NSError *error, MyCacheType cacheType, BOOL finished, NSString *url) {
        if (finished) {
            NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@",str);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
