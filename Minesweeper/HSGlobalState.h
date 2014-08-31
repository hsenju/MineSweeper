//
//  HSGlobalState.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSPosition.h"

#define GSTATE [HSGlobalState state]
#define Settings [NSUserDefaults standardUserDefaults]

@interface HSGlobalState : NSObject

@property (nonatomic, readonly) NSInteger dimension;
@property (nonatomic, readonly) NSInteger tileSize;
@property (nonatomic, readonly) NSInteger borderWidth;
@property (nonatomic, readonly) NSInteger cornerRadius;
@property (nonatomic, readonly) NSInteger horizontalOffset;
@property (nonatomic, readonly) NSInteger verticalOffset;
@property (nonatomic, readonly) NSTimeInterval animationDuration;

@property (nonatomic) BOOL needRefresh;

+ (HSGlobalState *)state;

- (void)loadGlobalState;

- (UIColor *)color;

- (UIColor *)textColor;

- (CGFloat)textSize;

- (CGPoint)locationOfPosition:(HSPosition)position;

- (CGFloat)xLocationOfPosition:(HSPosition)position;

- (CGFloat)yLocationOfPosition:(HSPosition)position;


- (CGVector)distanceFromPosition:(HSPosition)oldPosition toPosition:(HSPosition)newPosition;

- (HSPosition)pointToPosition:(CGPoint)point;
@end
