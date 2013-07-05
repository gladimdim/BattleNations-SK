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
#import "GameDictProcessor.h"
#import "DataPoster.h"
@interface GameBoardViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnUndo;
@property HelloScene *helloScene;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *armySelectionView;
@property NSDictionary *dictOfGame;
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
    BOOL myTurn = [self.match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID];
    if (myTurn) {
        self.navigationItem.title = NSLocalizedString(@"Make your turn 0/5", nil);
    }
    else {
        self.navigationItem.title = NSLocalizedString(@"Wait for opponent", nil);
    }
    [self.btnUndo setTitle:[NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), 0] forState:UIControlStateNormal];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkIfFirstMove];
}

-(void) showGameScene {
    self.helloScene = [[HelloScene alloc] initWithSize:self.view.frame.size dictOfGame:self.dictOfGame];
    SKView *spriteView = (SKView *) self.view;
    UIButton *buttonUndo = self.btnUndo;
    UINavigationItem *navItem = self.navigationItem;
    self.helloScene.callBackBlockTurnMade = ^(NSInteger turn) {
        navItem.title = [NSString stringWithFormat:NSLocalizedString(@"Make turn %i/5", nil), turn];
        [buttonUndo setTitle:[NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), turn] forState:UIControlStateNormal];
    };
    [spriteView presentScene:self.helloScene];
}

-(void) checkIfFirstMove {
    [self.match loadMatchDataWithCompletionHandler:^(NSData *matchData, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:matchData];
            if (dict) {
                self.dictOfGame = dict;
                NSDictionary *dictOfPlayer = [dict objectForKey:[GKLocalPlayer localPlayer].playerID];
                if (!dictOfPlayer) {
                    [self toggleArmySelection];
                }
                else {
                    [self showGameScene];
                }
            }
            else {
                [self toggleArmySelection];
            }
            NSLog(@"unarchived dict: %@", dict);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnUkrainePressed:(id)sender {
    self.dictOfGame = [GameLogic initPlayerInGameWithNation:@"ukraine" forDictOfGame:self.dictOfGame];
    [self showGameScene];
    [self toggleArmySelection];
}
- (IBAction)btnPolandPressed:(id)sender {
    self.dictOfGame = [GameLogic initPlayerInGameWithNation:@"poland" forDictOfGame:self.dictOfGame];
    [self showGameScene];
    [self toggleArmySelection];
}

- (IBAction)undoButtonPressed:(id)sender {
    NSInteger turn = [self.helloScene undoTurnAndReturnWhichTurn];
    [self.btnUndo setTitle:[NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), turn] forState:UIControlStateNormal];
}

- (IBAction)btnSendPressed:(id)sender {
    [self sendGameToServer];
}

- (IBAction)btnMenuPressed:(id)sender {
    [self toggleMenu];
}

-(void) toggleArmySelection {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    if (self.armySelectionView.frame.origin.x < 0) {
        [self.armySelectionView setFrame:CGRectMake(145, 145, 200, 75)];
    }
    else {
        [self.armySelectionView setFrame:CGRectMake(-400, 145, 200, 75)];
    }
    [UIView commitAnimations];
}

-(void) toggleMenu {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    if (self.menuView.frame.origin.y < 0) {
        [self.menuView setFrame:CGRectMake(280, 0, 200, 100)];
    }
    else {
        [self.menuView setFrame:CGRectMake(280, -400, 200, 100)];
    }
    [UIView commitAnimations];
}

-(void) sendGameToServer {
    /*NSString *playerID = [[NSUserDefaults standardUserDefaults] stringForKey:@"playerID"];
    if ([self.helloScene.gameObj isMyTurn:playerID]) {
        DataPoster *poster = [[DataPoster alloc] init];
        [self.helloScene.gameObj changeTurnToOtherPlayer];
        [poster sendMoves:self.helloScene.arrayOfMoves forGame:self.helloScene.gameObj withCallBack:^(BOOL success) {
            NSLog(@"Sent moves: %@", success ? @"YES" : @"NO");
            [self toggleMenu];
            self.navigationItem.title = NSLocalizedString(@"Turn sent", nil);
            self.btnMenu.enabled = NO;
        }];
    }
    else {
        NSLog(@"Sending denied: it is not your turn");
        self.navigationItem.title = NSLocalizedString(@"Not your turn", nil);
    }*/
     
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.helloScene.gameObj.dictOfGame];
    GKTurnBasedParticipant *oppositePart;
    for (GKTurnBasedParticipant *part in self.match.participants) {
        if (![[GKLocalPlayer localPlayer].playerID isEqualToString:part.playerID]) {
            oppositePart = part;
            break;
        }
    }
    [self.match endTurnWithNextParticipants:@[oppositePart] turnTimeout:GKTurnTimeoutDefault matchData:data completionHandler:^(NSError *err) {
        if (err) {
            NSLog(@"erorr during sending turn: %@", err.localizedDescription);
        }
        else {
            NSLog(@"turn sent!");
        }
    }];

}



@end
