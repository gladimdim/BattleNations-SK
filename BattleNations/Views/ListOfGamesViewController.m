//
//  ListOfGamesViewController.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "ListOfGamesViewController.h"
#import "ListOfGamesGetter.h"
#import "GameDictProcessor.h"
#import "GameBoardViewController.h"

@interface ListOfGamesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayOfGames;
- (IBAction)btnRefreshPressed:(id)sender;
@property NSArray *arrayOfMatches;
@property NSArray *arrayOfPlayersIDs;
@end

@implementation ListOfGamesViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [self getListOfGames];
}

-(void) getListOfGames {
   /* ListOfGamesGetter *getter = [[ListOfGamesGetter alloc] init];
    [getter getListOfGamesFor:[[NSUserDefaults standardUserDefaults] stringForKey:@"playerID"] withCallBack:^(NSDictionary *dict, NSError *err) {
        if (err) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:err.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        //check if returned object is dictionary with error or array with objects.
        SEL selectorAllKeys = NSSelectorFromString(@"allKeys");
        if ([dict respondsToSelector:selectorAllKeys]) {// && [dict allKeys].count > 1) {
            return;
        }
        else {
            NSArray *array = (NSArray *) dict;
            NSLog(@"amount of games: %i", array.count );
            NSMutableArray *arrayOfGameDicts = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *game = [array[i] objectForKey:@"game"];
                GameDictProcessor *gameObj = [[GameDictProcessor alloc] initWithDictOfGame:game gameLogic:nil];
                [arrayOfGameDicts addObject:gameObj];
            }
            self.arrayOfGames = [NSArray arrayWithArray:arrayOfGameDicts];
            [self.tableView reloadData];
        }
    }];*/
    
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        if (matches) {
          //  NSLog(@"matched: %@", matches);
            self.arrayOfMatches = matches;
            NSMutableArray *arrayOfPlayers = [NSMutableArray array];
            for (GKTurnBasedMatch *match in matches) {
                NSArray *participants = match.participants;
                for (GKTurnBasedParticipant *part in participants) {
                    if (part.playerID) {
                        [arrayOfPlayers addObject:part.playerID];
                    }
                }
            }
            self.arrayOfPlayersIDs = arrayOfPlayers;
            [self.tableView reloadData];
           // [self loadPlayerIDs];
        }
    }];
}

-(void) loadPlayerIDs {
    [GKPlayer loadPlayersForIdentifiers:self.arrayOfPlayersIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error !=nil) {
            for (GKPlayer *player in players) {
                NSLog(@"player names: %@", player.displayName);
            }
        }
        else {
            NSLog(@"error during loading player ids: %@", error.localizedDescription);
        }
    }];

}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMatches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellGame";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //GameDictProcessor *gameObj = (GameDictProcessor *) self.arrayOfGames[indexPath.row];
    GKTurnBasedMatch *match = (GKTurnBasedMatch *) self.arrayOfMatches[indexPath.row];
    NSArray *participants = match.participants;
    if ([[GKLocalPlayer localPlayer].playerID isEqualToString:match.currentParticipant.playerID]) {
        cell.backgroundColor = [UIColor greenColor];
    }
    else {
        cell.backgroundColor = [UIColor grayColor];
    }

    GKTurnBasedParticipant *part1 = participants[0];
    UILabel *labelLeft = (UILabel *) [cell viewWithTag:2];
    labelLeft.text = part1.playerID;
    GKTurnBasedParticipant *part2 = (GKTurnBasedParticipant *) participants[1];
    UILabel *labelRight = (UILabel *) [cell viewWithTag:3];
    labelRight.text = part2.playerID;
    
  /*  UIImageView *leftImage = (UIImageView *) [cell viewWithTag:1];
    leftImage.image = [gameObj imageForLeftPlayersNation];
    
    UIImageView *rightImage = (UIImageView *) [cell viewWithTag:4];
    rightImage.image = [gameObj imageForRightPlayersNation];
*/
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showGameScene" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGameScene"]) {
        GameBoardViewController *gc = (GameBoardViewController*) segue.destinationViewController;
        GKTurnBasedMatch *match = (GKTurnBasedMatch *) [self.arrayOfMatches objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        gc.match = match;
    }
}

- (IBAction)btnRefreshPressed:(id)sender {
    [self getListOfGames];
}
- (IBAction)btnRemoveGamesPressed:(id)sender {
    for (GKTurnBasedMatch *match in self.arrayOfMatches) {
        [match removeWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"Error while deleting game: %@", error.localizedDescription);
            }
        }];
    }
}
@end
