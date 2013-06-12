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

@interface ListOfGamesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayOfGames;
- (IBAction)btnRefreshPressed:(id)sender;
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
    ListOfGamesGetter *getter = [[ListOfGamesGetter alloc] init];
    [getter getListOfGamesFor:@"gladimdim" withCallBack:^(NSDictionary *dict, NSError *err) {
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
            NSMutableArray *arrayOfGameObj = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *game = [array[i] objectForKey:@"game"];
                GameDictProcessor *gameObj = [[GameDictProcessor alloc] initWithDictOfGame:game];
                [arrayOfGameObj addObject:gameObj];
            }
            self.arrayOfGames = [NSArray arrayWithArray:arrayOfGameObj];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfGames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellGame";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    GameDictProcessor *gameObj = (GameDictProcessor *) self.arrayOfGames[indexPath.row];
    
    UILabel *labelLeft = (UILabel *) [cell viewWithTag:2];
    labelLeft.text = [gameObj leftPlayerID];
    
    UILabel *labelRight = (UILabel *) [cell viewWithTag:3];
    labelRight.text = [gameObj rightPlayerID];
    
    UIImageView *leftImage = (UIImageView *) [cell viewWithTag:1];
    leftImage.image = [gameObj imageForLeftPlayersNation];
    
    UIImageView *rightImage = (UIImageView *) [cell viewWithTag:4];
    rightImage.image = [gameObj imageForRightPlayersNation];

    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (IBAction)btnRefreshPressed:(id)sender {
    [self getListOfGames];
}
@end
