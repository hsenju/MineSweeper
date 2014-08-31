//
//  HSCell.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSCell.h"

#import "HSCell.h"
#import "HSTile.h"

@implementation HSCell

- (instancetype)initWithPosition:(HSPosition)position
{
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    return self;
}


- (void)setTile:(HSTile *)tile
{
    _tile = tile;
    if (tile) tile.cell = self;
}

@end
