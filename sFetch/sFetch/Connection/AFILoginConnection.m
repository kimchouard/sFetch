//
//  AFILoginConnection.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFILoginConnection.h"

@implementation AFILoginConnection

- (id)initWithRequest:(NSMutableURLRequest *)request
             delegate:(id)delegate
                login:(NSString *)login
          andPassword:(NSString *)password
{
    self.login = login;
    self.password = password;
    self.delegate = delegate;
//    [self setHTTPAuthorizationHeaderToRequest:request];
    self = [super initWithRequest:request delegate:self];
    if (self) {
        
    }
    return self;
}

+ (AFIURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request
                                   delegate:(id)delegate
                                      login:(NSString *)login
                                andPassword:(NSString *)password
{
    AFIURLConnection *connection = [[AFIURLConnection alloc] initWithRequest:request
                                                                    delegate:delegate
                                                                       login:login
                                                                 andPassword:password];
    return connection;
}

@end
