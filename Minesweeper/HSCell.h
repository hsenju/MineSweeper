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

@property (nonatomic) HSPosition position;

@property (nonatomic, strong) HSTile *tile;

- (instancetype)initWithPosition:(HSPosition)position;

@end
