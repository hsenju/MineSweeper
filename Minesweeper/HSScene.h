//
//  HSMyScene.h
//  Minesweeper
//

//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class HSGrid;
@class HSViewController;

@interface HSScene : SKScene

@property (nonatomic, weak) HSViewController *delegate;

- (void)startNewGame;

- (void)loadBoardWithGrid:(HSGrid *)grid;

@end
