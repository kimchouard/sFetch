//
//  AFITimeLine.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFITimeLine.h"

@interface AFITimeLine()

@property (strong, nonatomic) NSArray *snippets;

@end

@implementation AFITimeLine

- (NSArray *)getSnippets
{
    return self.snippets;
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        [self setFromJson:json];
    }
    return self;
}

+ (AFITimeLine *)timeLineWithJson:(NSDictionary *)json
{
    return [[AFITimeLine alloc] initWithJson:json];
}

- (void)setFromJson:(NSDictionary *)json
{
    NSArray *snippetsInfo = [json objectForKey:@"datas"];
    NSMutableArray *tempSnippets = [[NSMutableArray alloc] initWithCapacity:[snippetsInfo count]];
    
    for (NSDictionary *snippetInfo in snippetsInfo) {
        AFISnippet *snippet = [AFISnippet snippetWithInfo:snippetInfo];
        [tempSnippets addObject:snippet];
    }
    
    self.snippets = tempSnippets;
}

@end
