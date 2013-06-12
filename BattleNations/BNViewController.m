//
//  BNViewController.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "BNViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HelloScene.h"

@interface BNViewController ()

@end

@implementation BNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsFPS = YES;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HelloScene *hello = [[HelloScene alloc] initWithSize:CGSizeMake(1024, 768)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene:hello];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
