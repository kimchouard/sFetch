//
//  AFIContactVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContactVC.h"
#import "AFISearchNavigationController.h"

@interface AFIContactVC ()

@end

@implementation AFIContactVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AFISearchNavigationController *navVC = (AFISearchNavigationController *)self.navigationController;
    
    [navVC setDisplayedSearchString:self.contact.lastName];
    navVC.lastContactViewed = self.contact;    
}

@end
