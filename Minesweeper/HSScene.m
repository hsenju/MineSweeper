//
//  HSMyScene.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//


#import "HSScene.h"
#import "HSGameManager.h"
#import "HSGridView.h"

#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@implementation HSScene {
    HSGameManager *_manager;
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _manager = [[HSGameManager alloc] init];
    }
    return self;
}

- (void)loadBoardWithGrid:(HSGrid *)grid
{
    UIImage *image = [HSGridView gridImageWithGrid:grid];
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:image.CGImage];
    SKSpriteNode *board = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    [board setScale:0.5];
    board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:board];
}


- (void)startNewGame
{

    
   [_manager startNewSessionWithScene:self];
}


# pragma mark - Swipe handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_manager touchedScreen:location];
       
    }
}

-(void)scenecheat{
    [_manager managercheat];
}

- (BOOL)validate{
    return [_manager managervalidate];
}

@end
