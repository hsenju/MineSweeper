//
//  HSGlobalState.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSGlobalState.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@interface HSGlobalState ()

@property (nonatomic, readwrite) NSInteger dimension;
@property (nonatomic, readwrite) NSInteger tileSize;
@property (nonatomic, readwrite) NSInteger borderWidth;
@property (nonatomic, readwrite) NSInteger cornerRadius;
@property (nonatomic, readwrite) NSInteger horizontalOffset;
@property (nonatomic, readwrite) NSInteger verticalOffset;
@property (nonatomic, readwrite) NSTimeInterval animationDuration;

@end


@implementation HSGlobalState

+ (HSGlobalState *)state
{
    static HSGlobalState *state = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        state = [[HSGlobalState alloc] init];
    });
    
    return state;
}


- (instancetype)init
{
    if (self = [super init]) {
        [self loadGlobalState];
    }
    return self;
}

- (void)loadGlobalState
{
    self.dimension = 8;
    self.borderWidth = 5;
    self.cornerRadius = 4;
    self.animationDuration = 0.1;
    self.horizontalOffset = [self horizontalOffset];
    self.verticalOffset = [self verticalOffset];
    self.needRefresh = NO;
}


- (NSInteger)tileSize
{
    return 30;
}


- (NSInteger)horizontalOffset
{
    CGFloat width = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth;
    return ([[UIScreen mainScreen] bounds].size.width - width) / 2;
}


- (NSInteger)verticalOffset
{
    CGFloat height = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth + 120;
    return ([[UIScreen mainScreen] bounds].size.height - height) / 2;
}

- (UIColor *)color
{
    return RGB(93, 125, 62);
}


- (UIColor *)textColor
{
    return [UIColor whiteColor];
}

- (CGFloat)textSize
{
    NSInteger offset = self.dimension == 5 ? 2 : 0;
    return 32 - offset;
}


# pragma mark - Position to point conversion

- (CGPoint)locationOfPosition:(HSPosition)position
{
    return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset,
                       [self yLocationOfPosition:position] + self.verticalOffset);
}


- (CGFloat)xLocationOfPosition:(HSPosition)position
{
    return position.y * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}


- (CGFloat)yLocationOfPosition:(HSPosition)position
{
    return position.x * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}

- (HSPosition)pointToPosition:(CGPoint)point
{
    return HSPositionMake((point.y  - self.verticalOffset - GSTATE.borderWidth)/(GSTATE.tileSize + GSTATE.borderWidth),
                       (point.x - self.horizontalOffset - GSTATE.borderWidth )/(GSTATE.tileSize + GSTATE.borderWidth));
}

- (CGVector)distanceFromPosition:(HSPosition)oldPosition toPosition:(HSPosition)newPosition
{
    CGFloat unitDistance = GSTATE.tileSize + GSTATE.borderWidth;
    return CGVectorMake((newPosition.y - oldPosition.y) * unitDistance,
                        (newPosition.x - oldPosition.x) * unitDistance);
}



@end
