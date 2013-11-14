//
//  AFIHomeVC.m
//  sFetch
//
//  Created by Kim Chouard on 11/14/13.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIHomeVC.h"

@interface AFIHomeVC ()

@end

@implementation AFIHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AFILoginVC"];
//    [self presentViewController:loginVC animated:YES completion:Nil];
}

@end
