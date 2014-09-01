//
//  HSGrid.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSCell.h"

@class HSScene;

typedef void (^IteratorBlock)(HSPosition);

@interface HSGrid : NSObject

@property (nonatomic, readonly) NSInteger dimension;

@property (nonatomic, weak) HSScene *scene;

- (instancetype)initWithDimension:(NSInteger)dimension;

- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse;

- (HSCell *)cellAtPosition:(HSPosition)position;

- (HSTile *)tileAtPosition:(HSPosition)position;

- (BOOL)hasAvailableCells;

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay;

- (void)insertTileAtPoint:(HSPosition)location grid:(HSGrid *)grid;

- (void)removeAllTilesAnimated:(BOOL)animated;

- (void)gridcheat: (HSGrid*)grid;

- (BOOL)gridvalidate:(HSGrid*)grid offset:(NSInteger)offset;

- (void)resetGameBool;
@end
