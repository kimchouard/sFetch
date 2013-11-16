//
//  AFILoginConnection.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFILoginConnection.h"
#import "AFIUser.h"

#define LOGIN_URL @"http://api.anyfetch.com"

@implementation AFILoginConnection

- (id)initWithDelegate:(id)delegate
                login:(NSString *)login
          andPassword:(NSString *)password
{    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LOGIN_URL]];
    
    self = [super initWithRequest:request delegate:delegate login:login andPassword:password];
    if (self) {
        
    }
    return self;
}

+ (AFILoginConnection *)connectionWithDelegate:(id)delegate
                                      login:(NSString *)login
                                andPassword:(NSString *)password
{
    return [[AFILoginConnection alloc] initWithDelegate:delegate
                                                  login:login
                                            andPassword:password];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [super connection:connection didReceiveData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [super connectionDidFinishLoading:connection];
}


@end
