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

@interface AFIContactVC () <UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AFIContactVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AFIProfileSumaryCell registerToCollectionview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AFISearchNavigationController *navVC = (AFISearchNavigationController *)self.navigationController;
    
    [navVC setDisplayedSearchString:self.contact.lastName];
    navVC.lastContactViewed = self.contact;    
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
            
            cell.firstNameLabel.text = self.contact.firstName;
            cell.lastNameLabel.text = self.contact.lastName;
            
            return cell;
        }
        case 1:
        {
            NSString *identifier = @"tempCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor greenColor];
            return cell;
        }
        case 2:
        {
            NSString *identifier = @"tempCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor blueColor];
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
}

#pragma mark UIPageControlDelegate

- (IBAction)pageControl:(UIPageControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.currentPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


@end
