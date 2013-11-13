//
//  AFIContact.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_KEY_NAME @"name"
#define SERVER_KEY_JOB @"job"
#define SERVER_KEY_IMG_URL @"image"

@interface AFIContact : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *job;
@property (strong, nonatomic) NSString *imageURL;


- (id)initLazy;
- (id)initWithInfo:(NSDictionary *)info;

+ (AFIContact *)defaultContact;

+ (AFIContact *)contactWithInfo:(NSDictionary *)info;

//+ (NSArray *)contactArrayWithDictionary:(NSDictionary *)dictionary;

@end
