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
    NSMutableArray *_grid;
    BOOL success;
}

- (instancetype)initWithDimension:(NSInteger)dimension
{
    if (self = [super init]) {
        _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
        
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
            for (NSInteger j = 0; j < dimension; j++) {
                [array addObject:[[HSCell alloc] initWithPosition:HSPositionMake(i, j)]];
            }
            [_grid addObject:array];
        }
        
        self.dimension = dimension;
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

- (HSCell *)randomAvailableCell
{
    NSArray *availableCells = [self availableCells];
    if (availableCells.count) {
        return [availableCells objectAtIndex:arc4random_uniform((int)availableCells.count)];
    }
    return nil;
}

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
        HSTile *tile = [instance insertNewTileToCell:cell];
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

- (void)insertTileAtPoint:(HSPosition)location grid:(HSGrid *)grid{
    HSCell *cell = [grid cellAtPosition:location];
    if (cell) {
        HSTile *tile = cell.tile;
//        uncomment this to cheat to check if its all working
//        if (tile.mine){
//            return;
//        }
        if (!tile.parent) {
            [self.scene addChild:tile];
            CGPoint origin = [GSTATE locationOfPosition:cell.position];
            tile.position = CGPointMake(origin.x + GSTATE.tileSize / 2, origin.y + GSTATE.tileSize / 2);
            [tile setScale:0];
            
            if (tile.zero){
                [grid forEach:^(HSPosition position) {
                    if ((cell == [grid cellAtPosition:position])) {
                        
                        HSTile *t1 = [grid tileAtPosition:HSPositionMake(position.x + 1, position.y)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t1.position] grid:grid];
                        HSTile *t2 = [grid tileAtPosition:HSPositionMake(position.x - 1, position.y)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t2.position] grid:grid];
                        HSTile *t3 = [grid tileAtPosition:HSPositionMake(position.x, position.y + 1)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t3.position] grid:grid];
                        HSTile *t4 = [grid tileAtPosition:HSPositionMake(position.x, position.y - 1)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t4.position] grid:grid];
                        HSTile *t5 = [grid tileAtPosition:HSPositionMake(position.x + 1, position.y + 1)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t5.position] grid:grid];
                        HSTile *t6 = [grid tileAtPosition:HSPositionMake(position.x - 1, position.y -1)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t6.position] grid:grid];
                        HSTile *t7 = [grid tileAtPosition:HSPositionMake(position.x -1, position.y + 1)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t7.position] grid:grid];
                        HSTile *t8 = [grid tileAtPosition:HSPositionMake(position.x + 1, position.y - 1)];
                        [self insertTileAtPoint:[GSTATE pointToPosition:t8.position] grid:grid];
                        
                    }
                } reverseOrder:TRUE];
            }

            if (tile.mine){
                [grid forEach:^(HSPosition position) {
                    if ([grid tileAtPosition:position].mine) {
                        [self insertTileAtPoint:position grid:grid];
                    }
                } reverseOrder:TRUE];
                success = false;
            }
            
            SKAction *delayAction = [SKAction waitForDuration:GSTATE.animationDuration * 3];
            SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
            [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[scale]]]]];
        }
    }
}

-(void)gridcheat: (HSGrid*)grid{
    [grid forEach:^(HSPosition position) {
        if ([grid tileAtPosition:position].mine) {
            [self insertTileAtPoint:position grid:grid];
        }
    } reverseOrder:TRUE];
}

- (void)resetGameBool{
    success = true;
}

- (BOOL)gridvalidate:(HSGrid *)grid offset:(NSInteger)offset{
    return (success && [[self.scene children] count] - offset == 54);
}

- (void)removeAllTilesAnimated:(BOOL)animated
{
    [self forEach:^(HSPosition position) {
        HSTile *tile = [self tileAtPosition:position];
        if (tile) [tile removeAnimated:animated];
    } reverseOrder:NO];
}

@end
