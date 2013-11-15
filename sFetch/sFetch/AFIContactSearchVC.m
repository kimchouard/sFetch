//
//  AFIViewController.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContactSearchVC.h"
#import "AFIContactList.h"
#import "AFISearchNavigationController.h"
#import "AFIContactVC.h"
#import "AFIURLConnectionFactory.h"
#import "AFIProfileButton.h"

#define CELL_IDENTIFIER @"contactCell"
#define SEGUE_IDENTIFIER @"displayContactSegue"
#define CONTACT_NUMBER 4

@interface AFIContactSearchVC () <UITableViewDataSource, AFISearchNavigationControllerDelegate, AFIURLConnectionDelegate, AFIContactListDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;

@property (strong, nonatomic) AFIURLConnection *contactsRequestConnection;

@property (strong, nonatomic) NSArray *data; // of AFIContact
@property (strong, nonatomic) NSArray *filteredData; // of AFIContact

@property (strong, nonatomic) AFISearchNavigationController *navVC; // never use or strong here, except for hackaton

@property (nonatomic) BOOL isSearching;
@property (nonatomic) BOOL firstAppearance;

@end

@implementation AFIContactSearchVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navVC = ((AFISearchNavigationController *) self.navigationController);
    self.navVC.searchDelegate = self;
    
    if (self.firstAppearance) {
        self.firstAppearance = NO;
    } else {
        [self.navVC showKeyboardAndCancelButton];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.navVC fixSearchBarToTop:NO];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstAppearance = YES;
    
    self.refreshControl= [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(requestContacts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
//    [self generateSampleData];
    
    [AFIContactList sharedList].delegate = self;
    [self reloadData];
    
    _isSearching = NO;
}

- (AFIURLConnection *)contactsRequestConnection
{
    if (!_contactsRequestConnection) {
        _contactsRequestConnection = [AFIURLConnectionFactory connectionGetContactWithDelegate:self];
    }
    return _contactsRequestConnection;
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

- (void)triggerAutoRefresh
{
    CGPoint newOffset = CGPointMake(0, -30);
    [self.tableView setContentOffset:newOffset animated:YES];
    [self.refreshControl beginRefreshing];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self requestContacts];
    });
}

- (void)reloadData
{
    self.data = [AFIContactList contacts];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark AFIURLConnectionDelegate

- (void)connectionDidStart:(AFIURLConnection *)connection
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    
    //NSLog(@"%@", json);
    
    [self.refreshControl endRefreshing];
    
    [AFIContactList setWithDictionary:json];
    [self reloadData];
    self.contactsRequestConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:self cancelButtonTitle:@"Retour" otherButtonTitles:nil] show];
    
    NSLog(@"%@", error);
    self.contactsRequestConnection = nil;
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
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = (![contact.job isKindOfClass:[NSNull class]]) ? contact.job : @"No job";
    
    return cell;
}

#pragma mark AFISearchNavigationControllerDelegate

- (BOOL)navigationSearchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)filterListForSearchText:(NSString *)searchText
{
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@ OR SELF.job contains[c] %@", searchText, searchText];
    
    self.filteredData = [self.data filteredArrayUsingPredicate:sPredicate];
}

- (void)navigationSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterListForSearchText:searchText];
    self.isSearching = (searchText.length);
    [self.tableView reloadData];
}

#pragma mark UIRefreshControlDelegate

- (void)requestContacts
{
    [self.contactsRequestConnection startConnection];
}

#pragma mark AFIContactListDelegate

- (void)contactListDidchange
{
    [self reloadData];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [((AFISearchNavigationController *)self.navigationController) hideKeyboardAndCancelButton];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER]) {
        if ([segue.destinationViewController isMemberOfClass:[AFIContactVC class]]) {
            AFIContactVC *destinationVC = (AFIContactVC *)segue.destinationViewController;
            
            [destinationVC requestTimeLine];
            
            if (self.isSearching) {
                destinationVC.contact = [self.filteredData objectAtIndex:indexPath.row];
            } else {
                destinationVC.contact = [self.data objectAtIndex:indexPath.row];
            }
        }
    }
}


@end
