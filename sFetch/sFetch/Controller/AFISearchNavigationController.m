//
//  AFISearchNavigationController.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFISearchNavigationController.h"
#import "AFIContact.h"

#define SEARCH_VC_INDEX 1

#define NAVBAR_TOP_FRAME CGRectMake(0, 0, 320, 64)
#define NAVBAR_CENTER_FRAME CGRectMake(0, 200, 320, 44)
#define SEARCHBAR_TOP_FRAME CGRectMake(44, 20, 276, 44)
#define SEARCHBAR_CENTER_FRAME CGRectMake(0, 0, 320, 44)


@interface AFISearchNavigationController () <UISearchBarDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIView *navigationBarView;

@property (strong, nonatomic) NSString *lastSearchedString;

@property (nonatomic) BOOL navBarFixedTop;

@end

@implementation AFISearchNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide nav bar
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [view setBackgroundColor:[UIColor colorWithRed:0.251 green:0.588 blue:0.263 alpha:1.0]];
    [self.view addSubview:view];
    
    
    // Replace by new one
    self.navigationBarView = [[UIView alloc] initWithFrame:NAVBAR_CENTER_FRAME];
    [self.navigationBarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationBarView];
    
    self.navBarFixedTop = NO;
    
    self.homeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.homeButton.frame = CGRectMake(0, 20, 44, 44);
    [self.homeButton setTitle:@"H" forState:UIControlStateNormal];
    self.homeButton.alpha = 0.0;
    [self.homeButton addTarget:self action:@selector(didTapHomeButton) forControlEvents:UIControlEventAllTouchEvents];
    
    [self.navigationBarView addSubview:self.homeButton];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:SEARCHBAR_CENTER_FRAME];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;

    [self.navigationBarView addSubview:self.searchBar];
}

- (void)fixSearchBarToTop:(BOOL)fixedTop
{
    if (fixedTop) {
        [self mooveNavBarUp];
    } else {
        [self mooveNavBarDown];
    }
    _navBarFixedTop = fixedTop;
}

- (void)mooveNavBarUp
{
    if (!self.navBarFixedTop) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.navigationBarView setFrame:NAVBAR_TOP_FRAME];
                             [self.searchBar setFrame:SEARCHBAR_TOP_FRAME];
                             self.homeButton.alpha = 1.0;
                         }
                         completion:Nil];
    }
}

- (void)mooveNavBarDown
{
    if (self.navBarFixedTop && [self.viewControllers count] == 1) {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.navigationBarView setFrame:NAVBAR_CENTER_FRAME];
                         [self.searchBar setFrame:SEARCHBAR_CENTER_FRAME];
                         self.homeButton.alpha = 0.0;
                     }
                     completion:Nil];
    }
}

- (void)showCancelButton
{
//    [self popToRootViewControllerAnimated:YES];
    [self popToSearchViewController];
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)showKeyboardAndCancelButton
{
    [self.searchBar becomeFirstResponder];
    [self showCancelButton];
}

- (void)hideKeyboardAndCancelButton
{
    [self fixSearchBarToTop:NO];
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
    [self fixSearchBarToTop:YES];
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
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self popToRootViewControllerAnimated:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    return [super popToViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
//    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    return [super popViewControllerAnimated:animated];
}

- (void)popToSearchViewController
{
    NSArray *viewControllers =  self.viewControllers;
    
    // > 2 means we opened more the timeline VC
    if ([viewControllers count] > 2) {
        [self popToViewController:[viewControllers objectAtIndex:SEARCH_VC_INDEX] animated:YES];
        [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    }
}

@end
