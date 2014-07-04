//
// Created by Kirill on 04.07.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KP_HTMLImagesCache.h"


@interface KP_WebviewWithCachedImages : UIWebView

@property (nonatomic, strong) NSMutableString *editedHtmlString;
@property (nonatomic, strong) NSArray *replacedLinks;


- (void)loadAndCacheHTMLString:(NSString *)htmlString;
@end