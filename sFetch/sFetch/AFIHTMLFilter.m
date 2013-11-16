//
//  AFIHTMLFilter.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIHTMLFilter.h"

@implementation AFIHTMLFilter

+ (NSString *)stringByStrippingHTML:(NSString *)string
{
    if (string) {
        NSRange r;
        while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            string = [string stringByReplacingCharactersInRange:r withString:@""];
    }
    return string;
}


@end
