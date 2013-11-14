//
//  AFIProfileTwitterCell.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFIProfileTwitterCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileLink;


+ (NSString *)reusableIdentifier;
+ (void)registerToCollectionview:(UICollectionView *)collectionview;

@end
