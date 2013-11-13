//
//  AFIPokeVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIPokeVC.h"

#define SEGUE_IDENTIFIER @"loginSegue"

@interface AFIPokeVC () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSURLConnection *loginConnection;

@end

@implementation AFIPokeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passwordLabel.secureTextEntry = YES;
    
    self.urlLabel.delegate = self;
    self.mailLabel.delegate =self;
    self.passwordLabel.delegate = self;
    
    self.activityIndicator.hidden = YES;
}

- (void)closeKeyboard
{
    [self.mailLabel resignFirstResponder];
    [self.urlLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pokeDisShit:textField];
    return YES;
}

- (IBAction)pokeDisShit:(id)sender
{
    [self closeKeyboard];
    
    NSString *URL = @"http://api.anyfetch.com";
    URL = self.urlLabel.text;
    NSString *login = @"dartus.pierremarie@gmail.com";
    login = self.mailLabel.text;
    NSString *password = @"Pmdmedrd";
    password = self.passwordLabel.text;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSString *loginPassword = [NSString stringWithFormat:@"%@:%@",login,password];
    NSLog(@"%@",loginPassword);
    
    NSData *plainData = [loginPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *value = [NSString stringWithFormat:@"Basic %@",base64String];
    NSLog(@"%@",value);
    NSDictionary *fields = @{@"Authorization" : value};
    
    [request setAllHTTPHeaderFields:fields];
    
    self.loginConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self startConnection];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activityIndicator stopAnimating];
    [self fetchedData:data];
}

- (void)startConnection
{
    [self.activityIndicator startAnimating];
    
    [self.loginConnection start];
}

#define ERROR_CODE_KEY @"code"
#define ERROR_MESSAGE_KEY @"message"

#define PROVIDER_STATUS_KEY @"provider_status"
#define PROVIDER_NAME_KEY @"name"

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    if ([json count] == 2) {
        [self accessRefusedWithJson:json];
    }
    
    NSArray *providerStatus = [json objectForKey:PROVIDER_STATUS_KEY];
    
    for (NSDictionary *provider in providerStatus) {
        NSString *name = [provider objectForKey:PROVIDER_NAME_KEY];
        //NSLog(@"name ='%@'", name);
        if ([name isEqualToString:@"Salesforce"] || [name isEqualToString:@"(local) Salesforce"]) {
            
            [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil] show];
}

- (void)accessRefusedWithJson:(NSDictionary *)json
{
    NSString *errorTitle = [json objectForKey:ERROR_CODE_KEY];
    NSString *errorMessage = [json objectForKey:ERROR_MESSAGE_KEY];
    
    [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil] show];
}

@end
