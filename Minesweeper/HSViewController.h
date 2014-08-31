//
//  HSViewController.h
//  Minesweeper
//

//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface HSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *minesweeperLabel;
@property (weak, nonatomic) IBOutlet UIButton *theNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *validateButton;
@property (weak, nonatomic) IBOutlet UIButton *cheatButton;
@end
