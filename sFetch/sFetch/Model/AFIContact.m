//
//  AFIContact.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContact.h"

#define ENCODE_KEY_JOB @"jobEncodeKey"
#define ENCODE_KEY_NAME @"nameEncodeKey"
#define ENCODE_KEY_IMG_URL @"imageURLEncodeKey"

static int contactNumber;

@interface AFIContact() <NSCoding>

@end

@implementation AFIContact

- (id)initLazy
{
    self = [self init];
    if (self) {
        _job = @"Job";
        _name = [NSString stringWithFormat:@"Name %d", contactNumber++];
    }
    return self;
}

- (id)initWithInfo:(NSDictionary *)info
{
    self = [self init];
    if (self) {
        _job = [info objectForKey:SERVER_KEY_JOB];
        _name = [info objectForKey:SERVER_KEY_NAME];
        _imageURL = [info objectForKey:SERVER_KEY_IMG_URL];
    }
    return self;
}

+ (AFIContact *)defaultContact
{
    return [[AFIContact alloc] initLazy];
}

+ (AFIContact *)contactWithInfo:(NSDictionary *)info
{
    return [[AFIContact alloc] initWithInfo:info];
}

//+ (NSArray *)contactArrayWithDictionary:(NSDictionary *)dictionary
//{
//    NSArray *documentArray = [dictionary objectForKey:@"datas"];
//    
//    NSMutableArray *tempData = [[NSMutableArray alloc] initWithCapacity:[documentArray count]];
//    
//    for (NSDictionary *contactDocument in documentArray) {
//        NSDictionary *contactInfo = [contactDocument objectForKey:@"datas"];
//        AFIContact *contact = [AFIContact contactWithInfo:contactInfo];
//        [tempData addObject:contact];
//    }
//    
//    return tempData;
//}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _job = [aDecoder decodeObjectForKey:ENCODE_KEY_JOB];
        _name = [aDecoder decodeObjectForKey:ENCODE_KEY_NAME];
        _imageURL = [aDecoder decodeObjectForKey:ENCODE_KEY_IMG_URL];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.job forKey:ENCODE_KEY_JOB];
    [aCoder encodeObject:self.name forKey:ENCODE_KEY_NAME];
    [aCoder encodeObject:self.imageURL forKey:ENCODE_KEY_IMG_URL];
}

@end
