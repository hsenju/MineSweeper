//
//  HSGridView.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSGridView.h"
#import "HSGrid.h"

@implementation HSGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.279 green:0.294 blue:0.290 alpha:1];
        self.layer.cornerRadius = GSTATE.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (instancetype)init
{
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    return [self initWithFrame:CGRectMake(GSTATE.horizontalOffset, verticalOffset - side, side, side)];
}


+ (UIImage *)gridImageWithGrid:(HSGrid *)grid
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.255 green:0.153 blue:0.341 alpha:1];
    
    HSGridView *view = [[HSGridView alloc] init];
    [backgroundView addSubview:view];
    
    [grid forEach:^(HSPosition position) {
        CALayer *layer = [CALayer layer];
        CGPoint point = [GSTATE locationOfPosition:position];
        
        CGRect frame = layer.frame;
        frame.size = CGSizeMake(GSTATE.tileSize, GSTATE.tileSize);
        frame.origin = CGPointMake(point.x, [[UIScreen mainScreen] bounds].size.height - point.y - GSTATE.tileSize);
        layer.frame = frame;
        
        layer.backgroundColor = [UIColor colorWithRed:0.757 green:0.667 blue:0.059 alpha:1].CGColor;
        layer.cornerRadius = GSTATE.cornerRadius;
        layer.masksToBounds = YES;
        [backgroundView.layer addSublayer:layer];
    } reverseOrder:NO];
    
    return [HSGridView snapshotWithView:backgroundView];
}


+ (UIImage *)gridImageWithOverlay
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.opaque = NO;
    
    HSGridView *view = [[HSGridView alloc] init];
    view.backgroundColor = [[UIColor colorWithRed:0.741 green:0.286 blue:0.263 alpha:1] colorWithAlphaComponent:0.8];
    [backgroundView addSubview:view];
    
    return [HSGridView snapshotWithView:backgroundView];
}


+ (UIImage *)snapshotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
