//
//  AFICallCenter.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 16/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFICallCenter.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation AFICallCenter

//using private API
//CoreTelephony framework is needed

extern NSString* const kCTSMSMessageReceivedNotification;
extern NSString* const kCTSMSMessageReplaceReceivedNotification;
extern NSString* const kCTSIMSupportSIMStatusNotInserted;
extern NSString* const kCTSIMSupportSIMStatusReady;

typedef struct __CTCall CTCall;
extern NSString *CTCallCopyAddress(void*, CTCall *);

void* CTSMSMessageSend(id server,id msg);
typedef struct __CTSMSMessage CTSMSMessage;
NSString *CTSMSMessageCopyAddress(void *, CTSMSMessage *);
NSString *CTSMSMessageCopyText(void *, CTSMSMessage *);

int CTSMSMessageGetRecordIdentifier(void * msg);
NSString * CTSIMSupportGetSIMStatus();
NSString * CTSIMSupportCopyMobileSubscriberIdentity();

id CTSMSMessageCreate(void* unknow/*always 0*/,NSString* number,NSString* text);
void * CTSMSMessageCreateReply(void* unknow/*always 0*/,void * forwardTo,NSString* text);

id CTTelephonyCenterGetDefault(void);
void CTTelephonyCenterAddObserver(id,id,CFNotificationCallback,NSString*,void*,int);
void CTTelephonyCenterRemoveObserver(id,id,NSString*,void*);
int CTSMSMessageGetUnreadCount(void);

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *notifyname=(__bridge NSString *)name;
    if ([notifyname isEqualToString:@"kCTCallIdentificationChangeNotification"])
    {
        NSDictionary *info = (__bridge NSDictionary *)userInfo;
        CTCall *call = (__bridge CTCall *)[info objectForKey:@"kCTCall"];
        NSString *caller = CTCallCopyAddress(NULL, call);
        NSLog(@"Caller %@",caller);
        if ([caller isEqualToString:@"+1555665753"])
        {
            //disconnect this call
//            CTCallDisconnect(call);
        }
    }
}

- (void)viewDidLoad
{
    id ct = CTTelephonyCenterGetDefault();
    CTTelephonyCenterAddObserver(ct, NULL,callback, NULL, NULL, CFNotificationSuspensionBehaviorHold);
    
    [super viewDidLoad];
}




@end
