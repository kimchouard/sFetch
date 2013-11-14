//
//  AFISnippetCell.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFISnippetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *sampleText;


+ (NSString *)reusableIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;

@end
