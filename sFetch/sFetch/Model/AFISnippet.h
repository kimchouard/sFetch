//
//  AFISnippets.h
//  sFetch
//
//  Created by Kim Chouard on 11/14/13.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_KEY_DATE @"creation_date"

//typedef NS_ENUM(int, AFISnippetType) {
//    AFISnippetTypeDocument,
//    AFISnippetTypeMail,
//    AFISnippetType,
//    AFISnippetType,
//    AFISnippetType
//};

@interface AFISnippet : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *source;

- (id)initWithInfo:(NSDictionary *)info;

+ (AFISnippet *)snippetWithInfo:(NSDictionary *)info;

@end