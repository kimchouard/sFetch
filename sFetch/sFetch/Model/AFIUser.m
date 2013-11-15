//
//  AFIUser.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIUser.h"

#define USER_FILE_PATH @"user.binary"

#define CONTACT_HISTORY_SIZE 10

#define ENCODE_KEY_LOGIN @"loginEncodeKey"
#define ENCODE_KEY_PASSWORD @"passwordEncodeKey"
#define ENCODE_KEY_HISTORY @"historyEncodeKey"

@interface AFIUser() <NSCoding>

@property (strong, nonatomic, readwrite) NSString *login;
@property (strong, nonatomic, readwrite) NSString *password;

@property (strong, nonatomic) NSArray *contactHistory;

@property (nonatomic) BOOL isCalling;
@property (nonatomic) BOOL isAuthentified;

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
    [aCoder encodeObject:self.contactHistory forKey:ENCODE_KEY_HISTORY];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _login = [aDecoder decodeObjectForKey:ENCODE_KEY_LOGIN];
        _password = [aDecoder decodeObjectForKey:ENCODE_KEY_PASSWORD];
        _contactHistory = [aDecoder decodeObjectForKey:ENCODE_KEY_HISTORY];
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
    
    AFIUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    return (user) ? user : [[AFIUser alloc] init];
}

#pragma mark Shared Instances

+ (AFIUser *)sharedUser
{
    static AFIUser *SharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!SharedUser) {
            SharedUser = [AFIUser unArchive];
            SharedUser.isCalling = NO;
            SharedUser.isAuthentified = NO;
        } else {
            NSLog(@"/!\\ Did not unarchive user.");
        }
        
    });
    return SharedUser;
}

+ (void)setCalling:(BOOL)isCalling
{
    [AFIUser sharedUser].isCalling = isCalling;
}

+ (BOOL)isCalling
{
    return [AFIUser sharedUser].isCalling;
}

+ (void)setAuthentifier:(BOOL)isAuthentified
{
    [AFIUser sharedUser].isAuthentified = isAuthentified;
}

+ (BOOL)isAuthentified
{
    return [AFIUser sharedUser].isAuthentified;
}

#pragma mark Contact history

@synthesize contactHistory = _contactHistory;

- (NSArray *)contactHistory
{
    if (!_contactHistory) _contactHistory = [[NSArray alloc] init];
    return _contactHistory;
}

- (void)setContactHistory:(NSArray *)contactHistory
{
    _contactHistory = contactHistory;
    [self archive];
}

- (void)addContactToHistory:(AFIContact *)contact
{
    NSMutableArray *tempHistory = [NSMutableArray arrayWithArray:self.contactHistory];

    [tempHistory insertObject:contact atIndex:0];
    
    if ([tempHistory count] > CONTACT_HISTORY_SIZE) {
        [tempHistory removeObject:[tempHistory lastObject]];
    }
    
    self.contactHistory = tempHistory;
}

+ (void)addContactToHistory:(AFIContact *)contact
{
    [[AFIUser sharedUser] addContactToHistory:contact];
}

+ (NSArray *)contactHistory
{
    return [AFIUser sharedUser].contactHistory;
}

@end
