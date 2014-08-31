//
//  HSGridView.h
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSGrid;

@interface HSGridView : UIView

+ (UIImage *)gridImageWithGrid:(HSGrid *)grid;

+ (UIImage *)gridImageWithOverlay;

@end
