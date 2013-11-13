//
//  AFIContactList.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFIContact.h"

@interface AFIContactList : NSObject

@property (nonatomic) BOOL isLoading;

+ (void)setWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)contacts;

@end
