//
//  BNViewController.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "GameBoardViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HelloScene.h"

@interface GameBoardViewController ()
- (IBAction)btnBackPressed:(id)sender;

@end

@implementation GameBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsFPS = YES;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    //[self.navigationController setNavigationBarHidden:YES];
    NSLog(@"view size: %@", NSStringFromCGSize(self.view.frame.size));
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    HelloScene *hello = [[HelloScene alloc] initWithSize:self.view.frame.size gameObj:self.dictOfGame];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene:hello];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
