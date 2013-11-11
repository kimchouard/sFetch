//
//  AFISearchNavigationController.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFISearchNavigationControllerDelegate;

@interface AFISearchNavigationController : UINavigationController


@property (weak) id <AFISearchNavigationControllerDelegate> searchDelegate;

@end

@protocol AFISearchNavigationControllerDelegate <NSObject>

@optional

- (BOOL)navigationSearchBarShouldBeginEditing:(UISearchBar *)searchBar;

@end
