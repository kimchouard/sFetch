//
//  AFIUser.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFIContact.h"

@interface AFIUser : NSObject


@property (strong, nonatomic, readonly) NSString *login;
@property (strong, nonatomic, readonly) NSString *password;


- (void)setLogin:(NSString *)login andPassword:(NSString *)password;

+ (void)setLogin:(NSString *)login andPassword:(NSString *)password;

- (void)addContactToHistory:(AFIContact *)contact;
+ (void)addContactToHistory:(AFIContact *)contact;


+ (AFIUser *)sharedUser;
+ (void)setCalling:(BOOL)isCalling;
+ (BOOL)isCalling;

+ (void)setAuthentifier:(BOOL)isAuthentified;
+ (BOOL)isAuthentified;

+ (NSArray *)contactHistory;

@end
