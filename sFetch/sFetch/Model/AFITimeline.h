//
//  AFITimeline.h
//  sFetch
//
//  Created by Kim Chouard on 11/14/13.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFISnippet.h"

@interface AFITimeline : NSObject

@property (strong, nonatomic) NSArray *snippets; // of AFISnippet

@end