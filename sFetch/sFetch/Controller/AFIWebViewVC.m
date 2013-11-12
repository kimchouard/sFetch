//
//  AFIWebViewVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIWebViewVC.h"

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
    
    NSString *URL = @"http://api.anyfetch.com";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSString *login = @"dartus.pierremarie@gmail.com";
    NSString *password = @"Pmdmedrd";
    
    NSString *loginPassword = [NSString stringWithFormat:@"%@:%@",login,password];
    NSLog(@"%@",loginPassword);
    
    NSData *plainData = [loginPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *value = [NSString stringWithFormat:@"Basic %@",base64String];
    NSLog(@"%@",value);
    NSDictionary *fields = @{@"Authorization" : value};
    
    [request setAllHTTPHeaderFields:fields];
    
    [self.webView loadRequest:request];
}

- (IBAction)sender:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
