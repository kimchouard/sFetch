//
//  AFIProfileSumaryCell.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFIProfileSumaryCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (NSString *)reusableIdentifier;
+ (void)registerToCollectionview:(UICollectionView *)collectionview;

@end
