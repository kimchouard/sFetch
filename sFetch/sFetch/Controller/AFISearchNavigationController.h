//
//  AFISearchNavigationController.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFIContactVC.h"

@protocol AFISearchNavigationControllerDelegate;

@interface AFISearchNavigationController : UINavigationController


@property (weak) id <AFISearchNavigationControllerDelegate> searchDelegate;
@property (strong, nonatomic) AFIContact *lastContactViewed;


- (void)showKeyboardAndCancelButton;
- (void)hideKeyboardAndCancelButton;

- (void)fixSearchBarToTop:(BOOL)fixedTop;

- (void)setDisplayedSearchString:(NSString *)string;



@end

@protocol AFISearchNavigationControllerDelegate <NSObject>

@optional

- (BOOL)navigationSearchBarShouldBeginEditing:(UISearchBar *)searchBar;

- (void)navigationSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
@end
