//
//  AFIProfileSumaryCell.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 12/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIProfileSumaryCell.h"

#define IDENTIFIER @"AFIProfileSumaryCell"

@implementation AFIProfileSumaryCell

+ (void)registerToCollectionview:(UICollectionView *)collectionview
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [collectionview registerNib:nib forCellWithReuseIdentifier:[AFIProfileSumaryCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

@end
