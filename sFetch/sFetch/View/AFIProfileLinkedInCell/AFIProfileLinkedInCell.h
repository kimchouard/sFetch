//
//  AFIProfileLinkedInCell.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFIProfileLinkedInCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextView *linkedInText;
@property (weak, nonatomic) IBOutlet UIButton *profileLink;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


+ (NSString *)reusableIdentifier;
+ (void)registerToCollectionview:(UICollectionView *)collectionview;

@end
