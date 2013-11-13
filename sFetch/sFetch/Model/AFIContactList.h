//
//  AFIContactList.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFIContact.h"

@protocol AFIContactListDelegate;

@interface AFIContactList : NSObject

@property (nonatomic) BOOL isLoading;

@property (weak, nonatomic) id <AFIContactListDelegate> delegate;

+ (AFIContactList *)sharedList;

+ (void)setWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)contacts;

+ (void)reload;

@end

@protocol AFIContactListDelegate <NSObject>

- (void)contactListDidchange;

@end
