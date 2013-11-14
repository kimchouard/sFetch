//
//  AFITimeLine.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFISnippet.h"

@interface AFITimeLine : NSObject

- (id)initWithJson:(NSDictionary *)json;

+ (AFITimeLine *)timeLineWithJson:(NSDictionary *)json;

- (NSArray *)getSnippets;

@end
