//
//  AFISnippetCell.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFISnippetCell.h"

#define IDENTIFIER @"AFISnippetCell"

@interface AFISnippetCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation AFISnippetCell


+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[AFISnippetCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

@end
