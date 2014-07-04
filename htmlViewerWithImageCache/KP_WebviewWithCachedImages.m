//
// Created by Kirill on 04.07.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <NSString-Hashes/NSString+Hashes.h>
#import <InnerBand/IBDispatchMessage.h>
#import "KP_WebviewWithCachedImages.h"
#import "IBMessageCenter.h"


@implementation KP_WebviewWithCachedImages

-(void)dealloc
{
    [IBMessageCenter removeMessageListenersForTarget:self];
}


-(void)loadAndCacheHTMLString:(NSString *)htmlString
{
    //save
    self.editedHtmlString = [htmlString mutableCopy];


    //change
    self.replacedLinks = [self replaceImgSources:self.editedHtmlString];


    //show
    [self loadHTMLString:self.editedHtmlString baseURL:nil];



    //start cache images
    for (NSString *link in self.replacedLinks)
    {
        [[KP_HTMLImagesCache sharedInstance] cacheImageWithLink:link];
    }



    [IBMessageCenter addGlobalMessageListener:KP_MSG_HTML_IMAGE_LOADED
                                       target:self
                                       action:@selector(onHtmlImageLoaded:)];

}



- (void)onHtmlImageLoaded:(IBDispatchMessage *)msg
{
    NSString *loadedLink = msg.userInfo[@"imageLink"];
    if ([self.replacedLinks containsObject:loadedLink])
    {
        [self loadHTMLString:self.editedHtmlString baseURL:nil];
    }
}



-(NSArray *)replaceImgSources:(NSMutableString *)htmlString
{
    __block NSMutableArray *replacedImageLinks = [NSMutableArray new];

    NSRegularExpression *regularExpression;
    NSString *regExPattern = @"<.*img.*?\\/>";
    regularExpression = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                             options:NSRegularExpressionAnchorsMatchLines
                                                               error:nil];

    NSArray *arrMatches;
    arrMatches = [regularExpression matchesInString:htmlString
                                            options:0
                                              range:NSMakeRange(0, htmlString.length)];




    for(NSTextCheckingResult *result in [arrMatches reverseObjectEnumerator])
    {
        NSString *imgTag;
        imgTag = [htmlString substringWithRange:result.range];

        NSRange srcRangeInsideTag = [self srcRangeInImgTag:imgTag];
        NSRange srcRangeInHtmlText = NSMakeRange(result.range.location+srcRangeInsideTag.location, srcRangeInsideTag.length);

        NSString *src = [htmlString substringWithRange:srcRangeInHtmlText];

        NSString *srcMD5 = [src md5];

        NSString *pathToLoadingImage = [[[NSBundle mainBundle] URLForResource:srcMD5 withExtension:nil] absoluteString];


        NSString *imagePath = [CACHE_PATH stringByAppendingPathComponent:srcMD5];

        [htmlString replaceCharactersInRange:srcRangeInHtmlText withString:[[NSURL fileURLWithPath:imagePath] absoluteString]];



        [replacedImageLinks addObject:src];
    }

    return replacedImageLinks;
}

-(NSRange)srcRangeInImgTag:(NSString *)imgTag
{
    int startRange;
    int lengthRange;
    //first replace all ' with "
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"'" withString:@"\""];

    NSString *scanResult = [NSString new];
    NSScanner *scanner = [[NSScanner alloc] initWithString:imgTag];
    [scanner scanUpToString:@"src" intoString:nil];
    [scanner scanUpToString:@"\"" intoString:nil];
    scanner.scanLocation = scanner.scanLocation+1;
    startRange = scanner.scanLocation;
    [scanner scanUpToString:@"\"" intoString:&scanResult];
    lengthRange = scanResult.length;

    return NSMakeRange(startRange, lengthRange);
}

@end