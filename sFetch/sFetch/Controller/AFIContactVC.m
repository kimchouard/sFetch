//
//  AFIContactVC.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIContactVC.h"
#import "AFISearchNavigationController.h"
#import "AFIProfileSumaryCell.h"
#import "AFIProfileTwitterCell.h"
#import "AFIProfileLinkedInCell.h"
#import "AFIProfileButton.h"
#import "AFIURLConnectionFactory.h"


@interface AFIContactVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, AFIURLConnectionDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;

@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *profileView;

@property (strong, nonatomic) AFIURLConnection *timeLineRequestConnection;

@end

@implementation AFIContactVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AFIProfileSumaryCell registerToCollectionview:self.collectionView];
    [AFIProfileTwitterCell registerToCollectionview:self.collectionView];
    [AFIProfileLinkedInCell registerToCollectionview:self.collectionView];
    
    self.refreshControl= [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(requestTimeLine) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self drawButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AFISearchNavigationController *navVC = (AFISearchNavigationController *)self.navigationController;
    
    [navVC setDisplayedSearchString:self.contact.name];
    navVC.lastContactViewed = self.contact;    
}

- (void)drawButtons
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"AFIProfileButton"
                                                         owner:self
                                                       options:nil];
    //I'm assuming here that your nib's top level contains only the view
    //you want, so it's the only item in the array.
    AFIProfileButton *mailButton = [nibContents objectAtIndex:0];
    mailButton.titleLabel.text = @"Mail";
    [mailButton setDesign];
    
    
    nibContents = [[NSBundle mainBundle] loadNibNamed:@"AFIProfileButton"
                                                         owner:self
                                                       options:nil];
    //I'm assuming here that your nib's top level contains only the view
    //you want, so it's the only item in the array.
    AFIProfileButton *callButton = [nibContents objectAtIndex:0];
    callButton.titleLabel.text = @"Call";
    [callButton setDesign];
    
    mailButton.frame = CGRectMake(0,95,160,25);
    [self.profileView addSubview:mailButton];
    callButton.frame = CGRectMake(160,95,160,25);
    [self.profileView addSubview:callButton];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            AFIProfileSumaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AFIProfileSumaryCell reusableIdentifier] forIndexPath:indexPath];
            
            cell.nameLabel.text = self.contact.name;
            //cell.jobLabel.text = self.contact.job;
            
            return cell;
        }
        case 1:
        {
            AFIProfileTwitterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AFIProfileTwitterCell reusableIdentifier] forIndexPath:indexPath];
            cell.nameLabel.text = self.contact.name;
            cell.tweetLabel.text = @"Mouahahah de la balle !";
            return cell;
        }
        case 2:
        {
            AFIProfileLinkedInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AFIProfileLinkedInCell reusableIdentifier] forIndexPath:indexPath];
            
            cell.nameLabel.text = self.contact.name;
            cell.linkedInText.text = @"URSS CEO";
            
            return cell;
        }
            default:
            return nil;
    }
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *visiblePath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    self.pageControl.currentPage = visiblePath.row;

    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:visiblePath];
    self.collectionView.backgroundColor = cell.backgroundColor;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark UIPageControlDelegate

- (IBAction)pageControl:(UIPageControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.currentPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark AFIURLConnectionDelegate

- (AFIURLConnection *)timeLineRequestConnection
{
    if (!_timeLineRequestConnection) {
        _timeLineRequestConnection = [AFIURLConnectionFactory connectionGetTimeLineForUserName:self.contact.name andDelegate:self];
    }
    return _timeLineRequestConnection;
}

- (void)requestTimeLine
{
    [self.timeLineRequestConnection startConnection];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

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
    
    NSLog(@"%@", json);
    
    [self.refreshControl endRefreshing];
    
//    [AFIContactList setWithDictionary:json];
    [self reloadData];
    self.timeLineRequestConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:self cancelButtonTitle:@"Retour" otherButtonTitles:nil] show];
    
    NSLog(@"%@", error);
    self.timeLineRequestConnection = nil;
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
    return [[UITableViewCell alloc] init];
}


@end
