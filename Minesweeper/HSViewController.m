//
//  HSViewController.m
//  Minesweeper
//
//  Created by Hikari Senju on 8/30/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSViewController.h"

#import "HSScene.h"
#import "HSGameManager.h"
#import "HSGridView.h"

@implementation HSViewController {
    
    HSScene *_scene;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView * skView = (SKView *)self.view;
    
    HSScene * scene = [HSScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    [scene startNewGame];
    
    _scene = scene;
}

- (IBAction)theNewGamePressed:(id)sender {
    [_scene startNewGame];
}

- (IBAction)validatePressed:(id)sender {
    if ([_scene validate]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                                        message:@"Congrats you win!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Fail!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cheatPressed:(id)sender {
    [_scene scenecheat];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
