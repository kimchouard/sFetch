//
//  AFIHomeVC.m
//  sFetch
//
//  Created by Kim Chouard on 11/14/13.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIHomeVC.h"
#import "AFIUser.h"
#import "AFIContactVC.h"
#import "AFIAppDelegate.h"
#import "AFISearchNavigationController.h"

#define CELL_IDENTIFIER @"contactCell"



@interface AFIHomeVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation AFIHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![AFIUser isAuthentified]) {
        UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AFILoginVC"];
        [self presentViewController:loginVC animated:YES completion:Nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((AFISearchNavigationController *)self.navigationController) hideKeyboardAndCancelButton];
    [self reloadData];
}

- (void)reloadData
{
    self.data = [AFIUser contactHistory];
    self.tableView.hidden = (![self.data count]);
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    AFIContact *contact = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = (![contact.job isKindOfClass:[NSNull class]]) ? contact.job : @"No job";
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recent";
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFIContact *contact = [self.data objectAtIndex:indexPath.row];
    AFIContactVC *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AFIContactVC"];
    destinationVC.contact = contact;
    
    [self performSegueWithIdentifier:@"contactSearchSegue" sender:self];
    UINavigationController *navVC = (UINavigationController *)[AFIAppDelegate topMostController];
    [navVC pushViewController:destinationVC animated:YES];
    
}

@end
