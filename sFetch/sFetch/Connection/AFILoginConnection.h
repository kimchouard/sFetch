//
//  AFILoginConnection.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIURLConnection.h"

@interface AFILoginConnection : AFIURLConnection


- (id)initWithRequest:(NSMutableURLRequest *)request
             delegate:(id) delegate
                login:(NSString *)login
          andPassword:(NSString *)password;

+ (AFIURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request
                                   delegate:(id)delegate login:(NSString *)login
                                andPassword:(NSString *)password;

@end
