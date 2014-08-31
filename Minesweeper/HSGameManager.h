//
//  HSGameManager.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSScene;
@class HSGrid;

@interface HSGameManager : NSObject

- (void)startNewSessionWithScene:(HSScene *)scene;

- (void)touchedScreen:(CGPoint)location;

- (void)managercheat;

- (BOOL)managervalidate;

@end
