//
//  HSTile.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HSGrid.h"

@class HSCell;

@interface HSTile : SKShapeNode
@property (nonatomic) NSInteger level;
@property (nonatomic) BOOL mine;
@property (nonatomic) BOOL zero;

@property (nonatomic, weak) HSCell *cell;

@property (weak, nonatomic) HSGrid *grid;

- (HSTile *)insertNewTileToCell:(HSCell *)cell;

- (void)commitPendingActions;

- (void)removeAnimated:(BOOL)animated;
@end
