//
//  HSGrid.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#include "stdlib.h"

#import "HSGrid.h"
#import "HSTile.h"
#import "HSScene.h"

@interface HSGrid ()

@property (nonatomic, readwrite) NSInteger dimension;

@end


@implementation HSGrid {
    /* The 2-D grid that keeps track of all cells and tiles. */
    NSMutableArray *_grid;
}

- (instancetype)initWithDimension:(NSInteger)dimension
{
    if (self = [super init]) {
        // Set up the grid with all empty cells.
        _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
        
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
            for (NSInteger j = 0; j < dimension; j++) {
                [array addObject:[[HSCell alloc] initWithPosition:HSPositionMake(i, j)]];
            }
            [_grid addObject:array];
        }
        
        // Record the dimension of the grid.
        self.dimension = dimension;
        
        // Draw the board.
    }
    
    return self;
}


# pragma mark - Iterator

- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse
{
    if (!reverse) {
        for (NSInteger i = 0; i < self.dimension; i++) {
            for (NSInteger j = 0; j < self.dimension; j++) {
                block(HSPositionMake(i, j));
            }
        }
    } else {
        for (NSInteger i = self.dimension - 1; i >= 0; i--) {
            for (NSInteger j = self.dimension - 1; j >= 0; j--) {
                block(HSPositionMake(i, j));
            }
        }
    }
}


# pragma mark - Position helpers

- (HSCell *)cellAtPosition:(HSPosition)position
{
    if (position.x >= self.dimension || position.y >= self.dimension ||
        position.x < 0 || position.y < 0) return nil;
    return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}


- (HSTile *)tileAtPosition:(HSPosition)position
{
    HSCell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}


# pragma mark - Cell availability

- (BOOL)hasAvailableCells
{
    return [self availableCells].count != 0;
}


/**
 * Returns a randomly chosen cell that's available.
 *
 * @return A randomly chosen available cell, or nil if no cell is available.
 */
- (HSCell *)randomAvailableCell
{
    NSArray *availableCells = [self availableCells];
    if (availableCells.count) {
        return [availableCells objectAtIndex:arc4random_uniform((int)availableCells.count)];
    }
    return nil;
}


/**
 * Returns all available cells in an array.
 *
 * @return The array of all available cells. If no cell is available, returns empty array.
 */
- (NSArray *)availableCells
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension * self.dimension];
    [self forEach:^(HSPosition position) {
        HSCell *cell = [self cellAtPosition:position];
        if (!cell.tile) [array addObject:cell];
    } reverseOrder:NO];
    return array;
}

# pragma mark - Cell manipulation

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay
{
    HSCell *cell = [self randomAvailableCell];
    if (cell) {
        HSTile *instance = [[HSTile alloc] init];
        [instance setGrid:self];
        NSLog(@"grid: %ld", (long)self.dimension);
        HSTile *tile = [instance insertNewTileToCell:cell grid:self];
        [self.scene addChild:tile];
        instance = nil;
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] :
        [SKAction waitForDuration:0];
        SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.tileSize / 2, - GSTATE.tileSize / 2)
                                 duration:GSTATE.animationDuration];
        SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
        [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[move, scale]]]]];
    }
}


- (void)removeAllTilesAnimated:(BOOL)animated
{
    [self forEach:^(HSPosition position) {
        HSTile *tile = [self tileAtPosition:position];
        if (tile) [tile removeAnimated:animated];
    } reverseOrder:NO];
}

@end
