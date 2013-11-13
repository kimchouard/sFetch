//
//  AFIPokeVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFILoginVC.h"
#import "AFILoginConnection.h"
#import "AFIContactList.h"

#define SEGUE_IDENTIFIER @"loginSegue"

@interface AFILoginVC () <AFIURLConnectionDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) AFILoginConnection *loginConnection;

@end

@implementation AFILoginVC

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
    
    NSString *URL;
    URL = self.urlLabel.text;
    NSString *login = @"dartus.pierremarie@gmail.com";
    login = self.mailLabel.text;
    NSString *password = @"Pmdmedrd";
    password = self.passwordLabel.text;
    
    
    self.loginConnection = [AFILoginConnection connectionWithDelegate:self
                                                                login:login
                                                          andPassword:password];
    
    [self.loginConnection startConnection];
}

- (void)performLogin
{
    [AFIContactList reload];
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
}

#pragma mark AFIURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activityIndicator stopAnimating];
    [self fetchedData:data];
}

- (void)connectionDidStart:(AFIURLConnection *)connection
{
    [self.activityIndicator startAnimating];
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
    
    BOOL success = NO;
    for (NSDictionary *provider in providerStatus) {
        NSString *name = [provider objectForKey:PROVIDER_NAME_KEY];
        if ([name isEqualToString:@"Salesforce"] || [name isEqualToString:@"(local) Salesforce"]) {
            success = YES;
        }
    }
    
    if (success) {
        [self performLogin];
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
