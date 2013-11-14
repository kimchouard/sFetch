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

+ (AFIURLConnection *)connectionGetTimeLineForUserName:(NSString *)name andDelegate:(id<AFIURLConnectionDelegate>)delegate
{
    NSString *URL = [NSString stringWithFormat:@"http://api.anyfetch.com/documents?search=%@", name];
    URL = @"http://bde.insa-lyon.fr/raid/wp-content/uploads/2013/11/bite.txt";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    return [AFIURLConnection connectionWithRequest:request delegate:delegate];
}

@end
