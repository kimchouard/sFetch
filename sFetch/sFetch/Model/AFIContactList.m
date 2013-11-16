//
//  AFIContactList.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContactList.h"
#import "AFIURLConnectionFactory.h"

#define CONTACTS_FILE_PATH @"contacts.binary"

@interface AFIContactList() <AFIURLConnectionDelegate>

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) AFIURLConnection *connection;

@end

@implementation AFIContactList

- (void)setWithDictionary:(NSDictionary *)dictionary
{
    NSArray *documentArray = [dictionary objectForKey:@"datas"];
    
    NSMutableArray *tempData = [[NSMutableArray alloc] initWithCapacity:[documentArray count]];
    
    for (NSDictionary *contactDocument in documentArray) {
        NSMutableDictionary *contactInfo = [contactDocument objectForKey:@"datas"];
        NSString *identifer = [contactDocument objectForKey:@"id"];
        AFIContact *contact = [AFIContact contactWithInfo:contactInfo andIdentifier:identifer];
        [tempData addObject:contact];
    }
    
    self.list = tempData;
    
    [self archive];
    
    if ([self.delegate respondsToSelector:@selector(contactListDidchange)]) {
        [self.delegate contactListDidchange];
    }
}

+ (void)setWithDictionary:(NSDictionary *)dictionary
{
    [[AFIContactList sharedList] setWithDictionary:dictionary];
}

+ (AFIContactList *)sharedList
{
    static AFIContactList *SharedList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedList = [[AFIContactList alloc] init];
        [SharedList unArchive];
    });
    return SharedList;
}

+ (NSArray *)contacts
{
    return [AFIContactList sharedList].list;
}

#pragma mark Archive

- (void)archive
{
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:CONTACTS_FILE_PATH];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("archive queue", NULL);
    dispatch_async(fetchQ, ^{
        if (![NSKeyedArchiver archiveRootObject:self.list toFile:path]) {
            NSLog(@"/!\\ Failed to archive contatcs.");
        }
    });
}

- (void)unArchive
{
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath =[applicationDocumentsDir stringByAppendingPathComponent:CONTACTS_FILE_PATH];
    
    NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (list) {
        self.list = list;
    }
}

#pragma mark AFIURLConnectionDelegate

- (AFIURLConnection *)connection
{
    if (!_connection) {
        _connection = [AFIURLConnectionFactory connectionGetContactWithDelegate:self];
    }
    return _connection;
}

- (void)reload
{
    [self.connection startConnection];
}

+ (void)reload
{
    [[AFIContactList sharedList] reload];
}

- (void)connectionDidStart:(AFIURLConnection *)connection
{
    self.isLoading = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    NSLog(@"ContactListDidReceiveData:\n%@", json);
    [self setWithDictionary:json];
    self.connection = Nil;
    self.isLoading = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:self cancelButtonTitle:@"Retour" otherButtonTitles:nil] show];
    
    self.isLoading = NO;
    self.connection = Nil;
    NSLog(@"ContactListDidFailData:\n%@", error);
}

@end
