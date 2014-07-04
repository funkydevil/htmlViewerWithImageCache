//
// Created by Kirill on 02.07.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "VCMain.h"
#import "KP_HTMLImagesCache.h"
#import "NSString+Hashes.h"
#import "IBMessageCenter.h"
#import "IBDispatchMessage.h"
#import "KP_WebviewWithCachedImages.h"


@implementation VCMain
{
    KP_WebviewWithCachedImages *_webView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    _webView = [[KP_WebviewWithCachedImages alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];

    NSMutableString *htmlString = [[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test.html"
                                                                                                    ofType:nil]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil] mutableCopy];

    [_webView loadAndCacheHTMLString:htmlString];
    _webView.backgroundColor = [UIColor redColor];
}










- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

@end