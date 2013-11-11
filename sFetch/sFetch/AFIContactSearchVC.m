//
//  AFIViewController.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContactSearchVC.h"
#import "AFIContact.h"

#define CELL_IDENTIFIER @"contactCell"
#define CONTACT_NUMBER 20

@interface AFIContactSearchVC () <UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *data; // of AFIContact
@property (strong, nonatomic) NSArray *filteredData; // of AFIContact

@property (nonatomic) BOOL isSearching;

@end

@implementation AFIContactSearchVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self generateSampleData];
    _isSearching = NO;
}

- (void)generateSampleData
{
    NSMutableArray *tempData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < CONTACT_NUMBER; i++) {
        AFIContact *contact = [AFIContact defaultContact];
        [tempData addObject:contact];
    }
    
    self.data = tempData;
}

#pragma mark Lazy instantiation

- (NSArray *)filteredData
{
    if (!_filteredData) _filteredData = [[NSArray alloc] init];
    return _filteredData;
}

- (void)setIsSearching:(BOOL)isSearching
{
    _isSearching = isSearching;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return [self.filteredData count];
    }
    else {
        return [self.data count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = CELL_IDENTIFIER;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    AFIContact *contact = nil;
    if (self.isSearching) {
        contact = [self.filteredData objectAtIndex:indexPath.row];
    } else {
        contact = [self.data objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = contact.lastName;
    cell.detailTextLabel.text = contact.firstName;
    
    return cell;
}

#pragma mark Kiki

- (void)filterListForSearchText:(NSString *)searchText
{
    //[self.filteredData removeAllObjects];
    
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF.lastName contains[c] %@", searchText];
    
    self.filteredData = [self.data filteredArrayUsingPredicate:sPredicate];
    
//    for (AFIContact *contact in self.data) {
//        NSRange firstNameRange = [contact.firstName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        NSRange lastNameRange = [contact.lastName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        if (lastNameRange.location != NSNotFound) {
//            [self.filteredData addObject:contact];
//        }
//    }
}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    self.isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    self.isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterListForSearchText:searchText];
    self.isSearching = (searchText.length);
    [self.tableView reloadData];
}


@end
