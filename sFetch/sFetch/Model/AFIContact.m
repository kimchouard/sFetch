//
//  AFIContact.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContact.h"

static int contactNumber;

@implementation AFIContact

- (id)initLazy
{
    self = [self init];
    if (self) {
        _firstName = @"FirstName";
        _lastName = [NSString stringWithFormat:@"LastName %d", contactNumber++];
    }
    return self;
}

+ (AFIContact *)defaultContact
{
    return [[AFIContact alloc] initLazy];
}

@end
