//
//  AFISnippets.m
//  sFetch
//
//  Created by Kim Chouard on 11/14/13.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFISnippet.h"
#import "AFIHTMLFilter.h"

@implementation AFISnippet

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        [self setWithInfo:info];
    }
    return self;
}

+ (AFISnippet *)snippetWithInfo:(NSDictionary *)info
{
    return [[AFISnippet alloc] initWithInfo:info];
}

- (void)setWithInfo:(NSDictionary *)info
{
    NSString *sDate = [info objectForKey:SERVER_KEY_DATE];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    [dateFormatter setLocale:enUSPOSIXLocale];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    
    _date = sDate; //[dateFormatter dateFromString:sDate];
    
    
    NSString *tempName = [[info objectForKey:@"datas"] objectForKey:@"title"];
    _name = [AFIHTMLFilter stringByStrippingHTML:tempName];
    
    
}

@end
