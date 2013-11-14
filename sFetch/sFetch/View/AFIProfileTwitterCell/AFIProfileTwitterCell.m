//
//  AFIProfileTwitterCell.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIProfileTwitterCell.h"

#define IDENTIFIER @"AFIProfileTwitterCell"

@interface AFIProfileTwitterCell()



@end

@implementation AFIProfileTwitterCell

+ (void)registerToCollectionview:(UICollectionView *)collectionview
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [collectionview registerNib:nib forCellWithReuseIdentifier:[AFIProfileTwitterCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

@end
