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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnUndo;
@property HelloScene *helloScene;
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
    self.btnUndo.title = [NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), 0];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.helloScene = [[HelloScene alloc] initWithSize:self.view.frame.size gameObj:self.dictOfGame];
    SKView *spriteView = (SKView *) self.view;
    self.helloScene.callBackBlockTurnMade = ^(NSInteger turn) {
        self.btnUndo.title = [NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), turn];
    };
    [spriteView presentScene:self.helloScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)undoButtonPressed:(id)sender {
    NSInteger turn = [self.helloScene undoTurnAndReturnWhichTurn];
    self.btnUndo.title = [NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), turn];
}

@end
