//
//  AFIURLConnection.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIURLConnection.h"

@interface AFIURLConnection() <NSURLConnectionDataDelegate>

@end;

@implementation AFIURLConnection

- (id)initWithRequest:(NSMutableURLRequest *)request
             delegate:(id)delegate
                login:(NSString *)login
          andPassword:(NSString *)password
{
    _login = login;
    _password = password;
    _delegate = delegate;
    [self setHTTPAuthorizationHeaderToRequest:request];
    self = [super initWithRequest:request delegate:self];
    if (self) {
        
    }
    return self;
}

+ (AFIURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request
                                   delegate:(id)delegate login:(NSString *)login
                                andPassword:(NSString *)password
{
    AFIURLConnection *connection = [[AFIURLConnection alloc] initWithRequest:request
                                                                    delegate:delegate
                                                                       login:login
                                                                 andPassword:password];
    return connection;
}

- (void)start
{
    [super start];
    if ([self.delegate respondsToSelector:@selector(connectionDidStart:)])
    {
        [self.delegate connectionDidStart:self];
    }
}

- (void)setHTTPAuthorizationHeaderToRequest:(NSMutableURLRequest *)request
{
    NSString *loginPassword = [NSString stringWithFormat:@"%@:%@",self.login,self.password];
    
    NSData *plainData = [loginPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *value = [NSString stringWithFormat:@"Basic %@",base64String];
    
    [request setValue:value forHTTPHeaderField:@"Authorization"];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.delegate connection:self didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.delegate connection:self didReceiveData:data];
    }
}

@end
