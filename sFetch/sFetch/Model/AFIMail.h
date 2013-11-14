//
//  AFIMail.h
//  sFetch
//
//  Created by Kim Chouard on 11/14/13.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFISnippet.h"

@interface AFIMail : AFISnippet

@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;

@end
