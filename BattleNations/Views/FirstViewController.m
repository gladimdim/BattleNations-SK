//
//  FirstViewController.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "FirstViewController.h"
#import "NewGame.h"

@interface FirstViewController ()
@property NSIndexPath *selectedIndex;
@property GKLocalPlayer *localPlayer;
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.selectedIndex = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self authenticateLocalPlayer];
    self.selectedIndex = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex && indexPath.row == self.selectedIndex.row) {
        return 88;
    }
    else {
        return 44;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row == 1 ? @"cellExpandable" : @"cellMain";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UILabel *labelView = (UILabel *) [cell viewWithTag:1];
    UIButton *buttonUkraine = (UIButton *) [cell viewWithTag:2];
    buttonUkraine.hidden = YES;
    UIButton *buttonPoland = (UIButton *) [cell viewWithTag:3];
    buttonPoland.hidden = YES;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Current Games", nil);
            break;
        case 1:
            labelView.text = NSLocalizedString(@"Start New Match", nil);
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"Login/Register", nil);
            break;
        default:
            break;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.selectedIndex = nil;
        [self.tableView reloadData];
        [self performSegueWithIdentifier:@"showListOfGames" sender:self];
    }
    else if (indexPath.row == 1) {
        /*self.selectedIndex = indexPath;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        UIButton *buttonUkraine = (UIButton *) [cell viewWithTag:2];
        buttonUkraine.hidden = NO;
        UIButton *buttonPoland = (UIButton *) [cell viewWithTag:3];
        buttonPoland.hidden = NO;*/
        [self joinMatch];
    }
    else if (indexPath.row == 2) {
        self.selectedIndex = nil;
        [self.tableView reloadData];
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
       /* self.selectedIndex = indexPath;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *buttonUkraine = (UIButton *) [cell viewWithTag:2];
        buttonUkraine.hidden = YES;
        UIButton *buttonPoland = (UIButton *) [cell viewWithTag:3];
        buttonPoland.hidden = YES;*/
    }
}

/************match making logic**************/
-(void) joinMatch {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKTurnBasedMatchmakerViewController *mc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mc.turnBasedMatchmakerDelegate = self;
    [self presentViewController:mc animated:YES completion:nil];
}

-(void) turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
    NSLog(@"match making cancelled");
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    NSLog(@"match making returned error %@", [error localizedDescription]);
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    NSLog(@"we've got new match: %@", match);
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    for (GKTurnBasedParticipant *part in match.participants) {
        if ([part.playerID isEqualToString:self.localPlayer.playerID]) {
            [part setMatchOutcome:GKTurnBasedMatchOutcomeWon];
            NSLog(@"Setting player won for playerQuitForMatch");
        }
        else {
            NSLog(@"Setting player lost for playerQuitForMatch");
            [part setMatchOutcome:GKTurnBasedMatchOutcomeLost];
        }
    }
    [match endMatchInTurnWithMatchData:nil completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error during playerQuitForMatch %@", error.localizedDescription);
        }
    }];
    NSLog(@"Player quit and match ended");
}
/*****************************************/


- (IBAction)btnUkrainePressed:(id)sender {
    [self startNewGameWithNation:@"ukraine"];
}
- (IBAction)btnPolandPressed:(id)sender {
    [self startNewGameWithNation:@"poland"];
}

-(void) startNewGameWithNation:(NSString *) nation {
    NewGame *game = [[NewGame alloc] init];
    [game askForNewGameForUser:[[NSUserDefaults standardUserDefaults] stringForKey:@"playerID"]  withEmail:[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] forNation:nation callBack:^(NSDictionary *returnDict, NSError *err) {
        NSLog(@"created new game: %@", returnDict);
        if (err) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error occurred", nil) message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Player put into queue", nil) message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *lPlayer = [GKLocalPlayer localPlayer];
    lPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            [self.navigationController pushViewController:viewController animated:YES];
            //            [self showAuthenticationDialogWhenReasonable: viewController]
        }
        else if (lPlayer.isAuthenticated)
        {
            NSLog(@"player authed");
            self.tableView.hidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
            self.localPlayer = lPlayer;
            //[self authenticatedPlayer: localPlayer];
        }
        else
        {
            self.tableView.hidden = YES;
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enable Game Center", nil) message:NSLocalizedString(@"Please enable Game Center. It is not possible to play without it.", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [view show];
            NSLog(@"disable GC");
            //            [self disableGameCenter];
        }
    };
}

@end
