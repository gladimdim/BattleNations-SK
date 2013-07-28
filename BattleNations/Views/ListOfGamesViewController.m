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
//array of GKPlayer - used for getting player photos
@property NSMutableArray *arrayOfGKPlayers;
@property NSArray *arrayOfPlayersIDs;
//maps player ids to display names
@property NSDictionary *dictOfPlayerNames;
@property NSMutableDictionary *dictOfPlayerPhotos;
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
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        if (matches) {
          //  NSLog(@"matched: %@", matches);
            self.arrayOfMatches = matches;
            NSMutableArray *arrayOfPlayerIDs = [NSMutableArray array];
            for (GKTurnBasedMatch *match in matches) {
                NSArray *participants = match.participants;
                for (GKTurnBasedParticipant *part in participants) {
                    if (part.playerID) {
                        [arrayOfPlayerIDs addObject:part.playerID];
                    }
                }
            }
            self.arrayOfPlayersIDs = arrayOfPlayerIDs;
            if (arrayOfPlayerIDs) {
                [self loadPlayerIDs];
            }
            
            [self.tableView reloadData];
        }
    }];
}

-(void) loadPlayerIDs {
    [GKPlayer loadPlayersForIdentifiers:self.arrayOfPlayersIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        if (!error) {
            self.arrayOfGKPlayers = [NSMutableArray array];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (GKPlayer *player in players) {
                [dict setObject:player.displayName forKey:player.playerID];
                [self.arrayOfGKPlayers addObject:player];
            }
            self.dictOfPlayerNames = dict;
            [self updatePhotosOfUsers];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"error during loading player ids: %@", error.localizedDescription);
        }
    }];
}

-(void) updatePhotosOfUsers {
    self.dictOfPlayerPhotos = [NSMutableDictionary dictionary];
    for (GKPlayer *player in self.arrayOfGKPlayers) {
        [player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
            if (!error) {
                [self.dictOfPlayerPhotos setObject:photo forKey:player.playerID];
                [self.tableView reloadData];
            }
            else {
                NSLog(@"Error %@ loading photo for player: %@", error.localizedDescription, player);
            }
        }];
    }
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
    labelLeft.text = self.arrayOfPlayersIDs ? [self.dictOfPlayerNames objectForKey:part1.playerID] : part1.playerID;
    GKTurnBasedParticipant *part2 = (GKTurnBasedParticipant *) participants[1];
    UILabel *labelRight = (UILabel *) [cell viewWithTag:3];
    labelRight.text = self.arrayOfPlayersIDs ? [self.dictOfPlayerNames objectForKey:part2.playerID] : part2.playerID;
    
    UIImageView *leftImage = (UIImageView *) [cell viewWithTag:1];
    //leftImage.image = ;//[self.dictOfPlayerPhotos objectForKey:part1.playerID];
    
    UIImageView *rightImage = (UIImageView *) [cell viewWithTag:4];
   // rightImage.image = ;// [self.dictOfPlayerPhotos objectForKey:part2.playerID];

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
