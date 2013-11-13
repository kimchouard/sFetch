//
//  AFIURLConnectionFactory.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIURLConnectionFactory.h"

@implementation AFIURLConnectionFactory

+ (AFIURLConnection *)connectionGetContactWithDelegate:(id<AFIURLConnectionDelegate>)delegate
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_CONTACTS_URL]];
    
    return [AFIURLConnection connectionWithRequest:request delegate:delegate];
}

@end
