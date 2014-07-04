//
// Created by Kirill on 02.07.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "KP_HTMLImagesCache.h"
#import "NSString+Hashes.h"
#import "IBMessageCenter.h"


@implementation KP_HTMLImagesCache

+ (KP_HTMLImagesCache *)sharedInstance
{
    static KP_HTMLImagesCache *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[KP_HTMLImagesCache alloc] init];
    });

    return _sharedInstance;
}


- (id)init
{
    if (self = [super init])
    {
        _arrDownloadRequest = [NSMutableArray new];
        [self makeCacheFolderIfNeed];
    }
    return self;
}




-(void)cacheImageWithLink:(NSString *)imageLink
{
    if (![self isImageAlreadyCached:imageLink])
    {
        NSString *hashMD5 = [imageLink md5];
        NSString *filePath = [CACHE_PATH stringByAppendingPathComponent:hashMD5];
        NSLog(@"save to %@",filePath);


        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^
        {
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageLink] options:0 error:nil];
            if (data)
            {
                [data writeToFile:filePath atomically:YES];
                dispatch_sync(dispatch_get_main_queue(), ^
                {
                    [IBMessageCenter sendGlobalMessageNamed:KP_MSG_HTML_IMAGE_LOADED withUserInfo:@{@"imageLink" : imageLink}];
                });
            }
        });
    }
}


-(BOOL)isImageAlreadyCached:(NSString *)imageLink
{
    NSString *hashMD5 = [imageLink md5];
    NSString *filePath = [CACHE_PATH stringByAppendingPathComponent:hashMD5];

    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


-(void)makeCacheFolderIfNeed
{
    NSFileManager* fm = [NSFileManager defaultManager];

    //make folder if need
    BOOL isDir;
    if (!([fm fileExistsAtPath:CACHE_PATH isDirectory:&isDir] && isDir))
    {

        [fm createDirectoryAtPath:CACHE_PATH withIntermediateDirectories:NO attributes:nil error:nil];
    }
}




@end