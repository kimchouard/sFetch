//
//  AFIViewController.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContactSearchVC.h"
#import "AFIContact.h"
#import "AFISearchNavigationController.h"
#import "AFIContactVC.h"

#define CELL_IDENTIFIER @"contactCell"
#define SEGUE_IDENTIFIER @"displayContactSegue"
#define CONTACT_NUMBER 20

@interface AFIContactSearchVC () <UITableViewDataSource, AFISearchNavigationControllerDelegate>

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
    
    ((AFISearchNavigationController *)self.navigationController).searchDelegate = self;
    
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

#pragma mark AFISearchNavigationControllerDelegate

- (BOOL)navigationSearchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)filterListForSearchText:(NSString *)searchText
{
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF.lastName contains[c] %@", searchText];
    
    self.filteredData = [self.data filteredArrayUsingPredicate:sPredicate];
}

- (void)navigationSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterListForSearchText:searchText];
    self.isSearching = (searchText.length);
    [self.tableView reloadData];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [((AFISearchNavigationController *)self.navigationController) hideKeyboardAndCancelButton];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER]) {
        if ([segue.destinationViewController isMemberOfClass:[AFIContactVC class]]) {
            AFIContactVC *destinationVC = (AFIContactVC *)segue.destinationViewController;
            
            if (self.isSearching) {
                destinationVC.contact = [self.filteredData objectAtIndex:indexPath.row];
            } else {
                destinationVC.contact = [self.data objectAtIndex:indexPath.row];
            }
        }
    }
}


@end
