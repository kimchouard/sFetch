//
//  AFIProfileButton.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 14/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIProfileButton.h"

@implementation AFIProfileButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDesign];
    }
    return self;
}

- (void)mooveTitle
{
    CGRect tempFrame = self.titleLabel.frame;
    tempFrame.origin.x = tempFrame.origin.x + ICON_SIZE/2.0;
    self.titleLabel.frame = tempFrame;
    [self setNeedsDisplay];
}

- (void)setDesign
{
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:BACKGROUND_ALPHA];
    [self mooveTitle];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDesign];
    }
    return self;
}



@end
