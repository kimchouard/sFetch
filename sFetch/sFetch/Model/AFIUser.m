//
//  AFIUser.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIUser.h"

#define USER_FILE_PATH @"user.binary"

#define ENCODE_KEY_LOGIN @"loginEncodeKey"
#define ENCODE_KEY_PASSWORD @"passwordEncodeKey"

@interface AFIUser() <NSCoding>

@property (strong, nonatomic, readwrite) NSString *login;
@property (strong, nonatomic, readwrite) NSString *password;

@end

@implementation AFIUser

- (void)setLogin:(NSString *)login andPassword:(NSString *)password
{
    self.login = login;
    self.password = password;
    
    [self archive];
}

+ (void)setLogin:(NSString *)login andPassword:(NSString *)password
{
    [[AFIUser sharedUser] setLogin:login andPassword:password];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.login forKey:ENCODE_KEY_LOGIN];
    [aCoder encodeObject:self.password forKey:ENCODE_KEY_PASSWORD];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _login = [aDecoder decodeObjectForKey:ENCODE_KEY_LOGIN];
        _password = [aDecoder decodeObjectForKey:ENCODE_KEY_PASSWORD];
    }
    return self;
}

- (void)archive
{
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:USER_FILE_PATH];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("archive queue", NULL);
    dispatch_async(fetchQ, ^{
        if (![NSKeyedArchiver archiveRootObject:self toFile:path]) {
            NSLog(@"/!\\ Failed to archive user.");
        }
    });
}

+ (AFIUser *)unArchive
{
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath =[applicationDocumentsDir stringByAppendingPathComponent:USER_FILE_PATH];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

#pragma mark Shared Instances

+ (AFIUser *)sharedUser
{
    static AFIUser *SharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!SharedUser) {
            SharedUser = [AFIUser unArchive];
        } else {
            NSLog(@"/!\\ Did not unarchive user.");
        }
        
    });
    return SharedUser;
}

@end
