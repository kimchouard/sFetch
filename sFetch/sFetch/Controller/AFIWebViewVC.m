//
//  AFIWebViewVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIWebViewVC.h"
#import "AFIUser.h"

@interface AFIWebViewVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AFIWebViewVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [self setHTTPAuthorizationHeaderToRequest:request];
    
    [self.webView loadRequest:request];
}

- (IBAction)sender:(id)sender
{
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setHTTPAuthorizationHeaderToRequest:(NSMutableURLRequest *)request
{
    AFIUser *user = [AFIUser sharedUser];
    NSString *loginPassword = [NSString stringWithFormat:@"%@:%@",user.login,user.password];
    
    NSData *plainData = [loginPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *value = [NSString stringWithFormat:@"Basic %@",base64String];
    
    [request setValue:value forHTTPHeaderField:@"Authorization"];
}

@end
