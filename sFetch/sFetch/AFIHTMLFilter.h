//
//  AFIHTMLFilter.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFIHTMLFilter : NSObject

+ (NSString *)stringByStrippingHTML:(NSString *)string;

@end
