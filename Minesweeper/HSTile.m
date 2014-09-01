//
//  HSTile.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//


#include <stdlib.h>

#import "HSTile.h"
#import "HSCell.h"

@interface HSTile ()


@end
@implementation HSTile {
    SKLabelNode *_value;
    
    NSMutableArray *_pendingActions;
}

- (HSTile *)insertNewTileToCell:(HSCell *)cell
{
    HSTile *tile = [[HSTile alloc] init];
    
    CGPoint origin = [GSTATE locationOfPosition:cell.position];
    tile.position = CGPointMake(origin.x + GSTATE.tileSize / 2, origin.y + GSTATE.tileSize / 2);
    [tile setScale:0];
    
    if (![[Settings valueForKey:@"Mine"]  isEqual: @"YES"]){
        [self updateGrid:_grid cell:cell tile:tile];
    }
    
    cell.tile = tile;
    return tile;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.mine = false;
        self.zero = false;
        
        CGRect rect = CGRectMake(0, 0, GSTATE.tileSize, GSTATE.tileSize);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, GSTATE.cornerRadius, GSTATE.cornerRadius, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
        
        _pendingActions = [[NSMutableArray alloc] init];
        _value = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-DemiBold"];
        _value.position = CGPointMake(GSTATE.tileSize / 2, GSTATE.tileSize / 2);
        _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        
        if ([[Settings valueForKey:@"Mine"]  isEqual: @"YES"]){
            [self addChild:_value];
        }
        
        [self refreshValue];
    }
    return self;
}

- (void)refreshValue
{
    if ([[Settings valueForKey:@"Mine"]  isEqual: @"YES"]){
        _value.text = [NSString stringWithFormat:@"M"];
        
        self.mine = true;
    }
    
    _value.fontColor = [GSTATE textColor];
    _value.fontSize = [GSTATE textSize];
    self.fillColor = [GSTATE color];
}

- (void)removeFromParentCell
{
    if (self.cell.tile == self) self.cell.tile = nil;
}


- (void)commitPendingActions
{
    [self runAction:[SKAction sequence:_pendingActions]];
    [_pendingActions removeAllObjects];
}

- (void)updateLevelTo:(NSInteger)level
{
    self.level = level;
    [_pendingActions addObject:[SKAction runBlock:^{
        [self refreshValue];
    }]];
}

-(void)updateGrid:(HSGrid *)grid cell:(HSCell *)cell tile:(HSTile*)tile
{

    [grid forEach:^(HSPosition position) {
        if ((cell == [grid cellAtPosition:position])) {
    
            int counter = 0;
            
            HSTile *t1 = [grid tileAtPosition:HSPositionMake(position.x + 1, position.y)];
            if (t1 && t1.mine) counter ++;
            HSTile *t2 = [grid tileAtPosition:HSPositionMake(position.x - 1, position.y)];
            if (t2 && t2.mine) counter ++;
            HSTile *t3 = [grid tileAtPosition:HSPositionMake(position.x, position.y + 1)];
            if (t3 && t3.mine) counter ++;
            HSTile *t4 = [grid tileAtPosition:HSPositionMake(position.x, position.y - 1)];
            if (t4 && t4.mine) counter ++;
            HSTile *t5 = [grid tileAtPosition:HSPositionMake(position.x + 1, position.y + 1)];
            if (t5 && t5.mine)counter ++;
            HSTile *t6 = [grid tileAtPosition:HSPositionMake(position.x - 1, position.y -1)];
            if (t6 && t6.mine)counter ++;
            HSTile *t7 = [grid tileAtPosition:HSPositionMake(position.x -1, position.y + 1)];
            if (t7 && t7.mine)counter ++;
            HSTile *t8 = [grid tileAtPosition:HSPositionMake(position.x + 1, position.y - 1)];
            if (t8 && t8.mine)counter ++;
            
            _value.text = [NSString stringWithFormat:@"%d", counter];
            [tile addChild:_value];
            
            if (counter ==0){
                tile.zero = true;
            }
            
            [tile refreshValue];
        }
    }reverseOrder:TRUE];
}

- (void)removeAnimated:(BOOL)animated
{
    [self removeFromParentCell];
    if (animated) [_pendingActions addObject:[SKAction scaleTo:0 duration:GSTATE.animationDuration]];
    [_pendingActions addObject:[SKAction removeFromParent]];
    [self commitPendingActions];
}

- (void)removeWithDelay
{
    [self removeFromParentCell];
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration];
    SKAction *remove = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[wait, remove]]];
}

- (SKAction *)pop
{
    CGFloat d = 0.15 * GSTATE.tileSize;
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration / 3];
    SKAction *enlarge = [SKAction scaleTo:1.3 duration:GSTATE.animationDuration / 1.5];
    SKAction *move = [SKAction moveBy:CGVectorMake(-d, -d) duration:GSTATE.animationDuration / 1.5];
    SKAction *restore = [SKAction scaleTo:1 duration:GSTATE.animationDuration / 1.5];
    SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:GSTATE.animationDuration / 1.5];
    
    return [SKAction sequence:@[wait, [SKAction group:@[enlarge, move]],
                                [SKAction group:@[restore, moveBack]]]];
}


@end
