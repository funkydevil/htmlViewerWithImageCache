//
// Created by Kirill on 02.07.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"htmlImagesCache"]

#define KP_MSG_HTML_IMAGE_LOADED @"KP_MSG_HTML_IMAGE_LOADED"


@interface KP_HTMLImagesCache : NSObject

@property (nonatomic, retain) NSString *myProperty;

+ (KP_HTMLImagesCache *)sharedInstance;
-(void)cacheImageWithLink:(NSString *)imageLink;

@property (nonatomic, strong) NSMutableArray *arrDownloadRequest;

@end








