//
//  AFISearchNavigationController.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFISearchNavigationController.h"
#import "AFIContact.h"


@interface AFISearchNavigationController () <UISearchBarDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) NSString *lastSearchedString;

@end

@implementation AFISearchNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [self.navigationItem.titleView addSubview:view];
    
    self.homeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.homeButton.frame = CGRectMake(0, 20, 44, 44);
    [self.homeButton setTitle:@"H" forState:UIControlStateNormal];
    [self.homeButton addTarget:self action:@selector(didTapHomeButton) forControlEvents:UIControlEventAllTouchEvents];
    
    [view addSubview:self.homeButton];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(44, 20, 276, 44)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;

    [view addSubview:self.searchBar];
}

- (void)showCancelButton
{
    [self popToRootViewControllerAnimated:YES];
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)showKeyboardAndCancelButton
{
    [self.searchBar becomeFirstResponder];
    [self showCancelButton];
}

- (void)hideKeyboardAndCancelButton
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)setDisplayedSearchString:(NSString *)string
{
    self.searchBar.text = string;
}

- (void)setLastContactViewed:(AFIContact *)lastContactViewed
{
    _lastContactViewed = lastContactViewed;
    self.lastSearchedString = _lastContactViewed.name;
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(navigationSearchBarShouldBeginEditing:)]) {
        [self.searchDelegate navigationSearchBarShouldBeginEditing:searchBar];
    }
    [self showCancelButton];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.lastContactViewed) {
        AFIContactVC *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AFIContactVC"];
        destinationVC.contact = self.lastContactViewed;
        [self pushViewController:destinationVC animated:YES];
    }
    
    [self hideKeyboardAndCancelButton];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchDelegate respondsToSelector:@selector(navigationSearchBar:textDidChange:)]) {
        [self.searchDelegate navigationSearchBar:searchBar textDidChange:searchText];
    }
    self.lastSearchedString = searchText;
    self.lastContactViewed = nil;
}


#pragma mark UIButton Delegate

- (void)didTapHomeButton
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    return [super popToViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    return [super popViewControllerAnimated:animated];
}

@end
