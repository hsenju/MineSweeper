//
//  HSCell.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSTile;

@interface HSCell : NSObject

/** The position of the cell. */
@property (nonatomic) HSPosition position;

/** The tile in the cell, if any. */
@property (nonatomic, strong) HSTile *tile;

/**
 * Initialize a M2Cell at the specified position with no tile in it.
 *
 * @param position The position of the cell.
 */
- (instancetype)initWithPosition:(HSPosition)position;

@end
