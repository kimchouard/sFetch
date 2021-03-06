//
//  AFIContact.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFITimeLine.h"

#define SERVER_KEY_NAME @"name"
#define SERVER_KEY_JOB @"job"
#define SERVER_KEY_IMG_URL @"image"
#define SERVER_KEY_IDENTIFIER @"id"

@interface AFIContact : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *job;
@property (strong, nonatomic) NSString *imageURL;

@property (strong, nonatomic) AFITimeLine *timeLine;


- (id)initLazy;
- (id)initWithInfo:(NSDictionary *)info;
- (id)initWithInfo:(NSDictionary *)info andIdentifier:(NSString *)identifier;

+ (AFIContact *)defaultContact;

+ (AFIContact *)contactWithInfo:(NSDictionary *)info;
+ (AFIContact *)contactWithInfo:(NSDictionary *)info andIdentifier:(NSString *)identifier;

@end
