//
//  AFIPokeVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIPokeVC.h"

@interface AFIPokeVC () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

@end

@implementation AFIPokeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passwordLabel.secureTextEntry = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pokeDisShit:(id)sender
{
    NSString *URL = @"http://api.anyfetch.com";
    URL = self.urlLabel.text;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSString *login = @"dartus.pierremarie@gmail.com";
    NSString *password = @"Pmdmedrd";
    
    login = self.mailLabel.text;
    password = self.passwordLabel.text;
    
    NSString *loginPassword = [NSString stringWithFormat:@"%@:%@",login,password];
    NSLog(@"%@",loginPassword);
    
    NSData *plainData = [loginPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *value = [NSString stringWithFormat:@"Basic %@",base64String];
    NSLog(@"%@",value);
    NSDictionary *fields = @{@"Authorization" : value};
    
    [request setAllHTTPHeaderFields:fields];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self fetchedData:data];
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    if ([json count] == 2) {
        [self connection:nil didFailWithError:error];
    }
    
    NSArray *providerStatus = [json objectForKey:@"provider_status"];
    
    for (NSDictionary *provider in providerStatus) {
        NSString *name = [provider objectForKey:@"name"];
        [[[UIAlertView alloc] initWithTitle:@"Provider Status" message:name delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil] show];
}
@end
