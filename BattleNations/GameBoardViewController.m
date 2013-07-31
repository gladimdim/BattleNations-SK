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

#define FOG_VIEW_TAG_ID 20

@implementation GameBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    }

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsFPS = YES;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    //[self.navigationController setNavigationBarHidden:YES];
    NSLog(@"view size: %@", NSStringFromCGSize(self.view.frame.size));
    BOOL myTurn = [self.match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID];
    if (myTurn) {
        self.navigationItem.title = NSLocalizedString(@"Turn 0/5", nil);
    }
    else {
        self.navigationItem.title = NSLocalizedString(@"Wait for opponent", nil);
        self.btnMenu.enabled = NO;
        [self showFogOverlay];
    }
    [self.btnUndo setTitle:[NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), 0] forState:UIControlStateNormal];
    [self checkIfFirstMove];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) showGameScene {
    self.helloScene = [[HelloScene alloc] initWithSize:self.view.frame.size dictOfGame:self.dictOfGame];
    SKView *spriteView = (SKView *) self.view;
    UIButton *buttonUndo = self.btnUndo;
    UINavigationItem *navItem = self.navigationItem;
    self.helloScene.callBackBlockTurnMade = ^(NSInteger turn) {
        navItem.title = [NSString stringWithFormat:NSLocalizedString(@"Turn %i/5", nil), turn];
        [buttonUndo setTitle:[NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), turn] forState:UIControlStateNormal];
    };
    self.helloScene.callBackBlockReplayTurnMade = ^(NSInteger turn) {
        navItem.title = [NSString stringWithFormat:NSLocalizedString(@"Enemy's turn %i/5", nil), turn];
        if (turn == 5) {
            navItem.title = NSLocalizedString(@"Turn 0/5", nil);
        }
        //[buttonUndo setTitle:[NSString stringWithFormat:NSLocalizedString(@"Undo %i/5", nil), turn] forState:UIControlStateNormal];
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
           // NSLog(@"unarchived dict: %@", dict);
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

- (IBAction)btnReplayPressed:(id)sender {
    [self.helloScene replayMoves];
}

-(void) toggleArmySelection {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    NSLog(@"army selection view: %@", NSStringFromCGRect(self.armySelectionView.frame));
    if (self.armySelectionView.frame.origin.x >= self.view.frame.size.width) {
        [self.armySelectionView setFrame:CGRectMake(self.view.frame.size.width / 2 - 100, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 75 : 0, 200, 75)];
    }
    else {
        [self.armySelectionView setFrame:CGRectMake(self.view.frame.size.width + 200, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 75 : 0, 200, 75)];
    }
    NSLog(@"army selection view: %@", NSStringFromCGRect(self.armySelectionView.frame));
    [UIView commitAnimations];
}

-(void) toggleMenu {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    NSLog(@"menuview: %@", NSStringFromCGRect(self.menuView.frame));
    if (self.menuView.frame.origin.x >= self.view.frame.size.width) {
        [self.menuView setFrame:CGRectMake(self.view.frame.size.width - 150, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 75 : 0, 150, 120)];
    }
    else {
        [self.menuView setFrame:CGRectMake(self.view.frame.size.width + 150, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 75 : 0, 150, 120)];
    }
    [UIView commitAnimations];
}

-(void) sendGameToServer {
    NSMutableDictionary *dictWithGameAndMoves = [NSMutableDictionary dictionaryWithDictionary:self.helloScene.gameObj.dictOfGame];
    [dictWithGameAndMoves setObject:self.helloScene.arrayOfMoves forKey:@"lastMoves"];
    [dictWithGameAndMoves setObject:self.helloScene.downloadedGameObj.dictOfGame forKey:@"initialTable"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictWithGameAndMoves];
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
            [self showFogOverlay];
            self.btnMenu.enabled = NO;
            [self toggleMenu];
            self.navigationItem.title = NSLocalizedString(@"Move sent. Wait for opponent.", nil);
            NSLog(@"turn sent!");
        }
    }];
}

-(void) showFogOverlay {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.8f];
    [view setTag:FOG_VIEW_TAG_ID];
    [self.view addSubview:view];
}

@end



