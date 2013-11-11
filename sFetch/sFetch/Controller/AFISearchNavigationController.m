//
//  AFISearchNavigationController.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFISearchNavigationController.h"


@interface AFISearchNavigationController () <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AFISearchNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [self.navigationItem.titleView addSubview:view];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 20.0, 320.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    [view addSubview:self.searchBar];
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(navigationSearchBarShouldBeginEditing:)]) {
        [self.searchDelegate navigationSearchBarShouldBeginEditing:searchBar];
    }
    [self popToRootViewControllerAnimated:YES];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchDelegate respondsToSelector:@selector(navigationSearchBar:textDidChange:)]) {
        [self.searchDelegate navigationSearchBar:searchBar textDidChange:searchText];
    }
}

@end
