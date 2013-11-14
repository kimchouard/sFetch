//
//  AFIProfileLinkedInCell.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIProfileLinkedInCell.h"

#define IDENTIFIER @"AFIProfileLinkedInCell"

@implementation AFIProfileLinkedInCell

+ (void)registerToCollectionview:(UICollectionView *)collectionview
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [collectionview registerNib:nib forCellWithReuseIdentifier:[AFIProfileLinkedInCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

@end
