//
//  HSGameManager.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSGameManager.h"
#import "HSGrid.h"
#import "HSScene.h"
#import "HSViewController.h"


@implementation HSGameManager {
    HSGrid *_grid;
    
    HSGrid *answerGrid;
    
    NSInteger offset;

}


# pragma mark - Setup

- (void)startNewSessionWithScene:(HSScene *)scene
{
    if (_grid && _grid.dimension == GSTATE.dimension) {
        [_grid removeAllTilesAnimated:YES];
    } else {
        if (_grid) [_grid removeAllTilesAnimated:NO];
        _grid = [[HSGrid alloc] initWithDimension:GSTATE.dimension];
        _grid.scene = scene;
    }
    
    [scene loadBoardWithGrid:_grid];

    [_grid resetGameBool];
    
    answerGrid = [[HSGrid alloc] init];
    if (answerGrid && answerGrid.dimension == GSTATE.dimension) {
        [answerGrid removeAllTilesAnimated:YES];
    } else {
        if (answerGrid) [answerGrid removeAllTilesAnimated:NO];
        answerGrid = [[HSGrid alloc] initWithDimension:GSTATE.dimension];
    }
    
    [Settings setValue:@"YES" forKey:@"Mine"];
    for (int i = 0; i<10; i++){
        [answerGrid insertTileAtRandomAvailablePositionWithDelay:NO];
    }
    [Settings setValue:@"NO" forKey:@"Mine"];
    for (int i = 0; i<56; i++){
        [answerGrid insertTileAtRandomAvailablePositionWithDelay:NO];
    }
    
    offset = [[scene children] count];
}


- (void)touchedScreen:(CGPoint)location{
    HSPosition point = [GSTATE pointToPosition:location];
    [_grid insertTileAtPoint:point grid:answerGrid];
}

- (void)managercheat{
    [_grid gridcheat: answerGrid];
}

- (BOOL)managervalidate{
    return [_grid gridvalidate: _grid offset: offset];
}

@end
