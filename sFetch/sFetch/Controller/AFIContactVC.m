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
#import "AFISnippetCell.h"
#import "AFIProfileButton.h"
#import "AFIURLConnectionFactory.h"
#import "AFITimeLine.h"
#import "MBProgressHUD.h"
#import "AFIUser.h"
#import "AFIWebViewVC.h"


@interface AFIContactVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, AFIURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;

@property (strong, nonatomic) MBProgressHUD *loadingView;

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
    [AFISnippetCell registerToTableView:self.tableView];
    
    [AFIUser addContactToHistory:self.contact];
    
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
    [mailButton setTitle:@"Mail" forState:UIControlStateNormal];
    [mailButton setDesign];
    [mailButton addTarget:self action:@selector(doMail) forControlEvents:UIControlEventAllTouchEvents];
    
    
    nibContents = [[NSBundle mainBundle] loadNibNamed:@"AFIProfileButton"
                                                         owner:self
                                                       options:nil];
    //I'm assuming here that your nib's top level contains only the view
    //you want, so it's the only item in the array.
    AFIProfileButton *callButton = [nibContents objectAtIndex:0];
    [callButton setTitle:@"Call" forState:UIControlStateNormal];
    [callButton setDesign];
    [callButton addTarget:self action:@selector(doCall) forControlEvents:UIControlEventAllTouchEvents];
    
    mailButton.frame = CGRectMake(0,95,160,25);
    [self.profileView addSubview:mailButton];
    callButton.frame = CGRectMake(160,95,160,25);
    [self.profileView addSubview:callButton];
}

- (void)doCall
{
    NSString *phoneNumber = @"1-800-555-1212"; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
    [AFIUser setCalling:YES];
}

- (void)doMail
{
    
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
    self.data = [self.contact.timeLine getSnippets];
    [self.tableView reloadData];
}

- (void)connectionDidStart:(AFIURLConnection *)connection
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 500)];
//    [self.view addSubview:view];
//    [self showLoadingViewInView:view];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    
//    NSLog(@"%@", json);
    self.contact.timeLine = [AFITimeLine timeLineWithJson:json];
    
    [self.refreshControl endRefreshing];
    
    [self reloadData];
    self.timeLineRequestConnection = nil;
    [self hideLoadingView];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:self cancelButtonTitle:@"Retour" otherButtonTitles:nil] show];
    
    NSLog(@"%@", error);
    self.timeLineRequestConnection = nil;
    [self hideLoadingView];
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
    AFISnippetCell *cell = [tableView dequeueReusableCellWithIdentifier:[AFISnippetCell reusableIdentifier] forIndexPath:indexPath];
    
    AFISnippet *snippet = [self.data objectAtIndex:indexPath.row];
    
    cell.dateLabel.text = snippet.date;
    cell.titleLabel.text = snippet.name;
    cell.sampleText.text = @"Nice !";
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFIWebViewVC *webViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AFIWebViewVC"];
    
    NSString *url = [@"http://api.anyfetch.com" stringByAppendingString: ((AFISnippet *) [self.data objectAtIndex:indexPath.row]).url];
    webViewVC.url = url;
    
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - MBProgressHUD

- (void) showLoadingViewInView:(UIView*)v
{
    UIView *targetV = (v ? v : self.view);
    
    if (!self.loadingView) {
        self.loadingView = [[MBProgressHUD alloc] initWithView:targetV];
        self.loadingView.minShowTime = 1.0f;
        self.loadingView.mode = MBProgressHUDModeIndeterminate;
        self.loadingView.removeFromSuperViewOnHide = YES;
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    if(!self.loadingView.superview) {
        self.loadingView.frame = targetV.bounds;
        [targetV addSubview:self.loadingView];
    }
    [self.loadingView show:YES];
}
- (void) hideLoadingView
{
    if (self.loadingView.superview)
        [self.loadingView hide:YES];
}


@end
