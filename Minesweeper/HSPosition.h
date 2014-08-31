//
//  EAGLSharegroup_HSPosition.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

typedef struct Position {
    NSInteger x;
    NSInteger y;
} HSPosition;

CG_INLINE HSPosition HSPositionMake(NSInteger x, NSInteger y)
{
    HSPosition position;
    position.x = x; position.y = y;
    return position;
}
