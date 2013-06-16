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
    self.selectedIndex = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
            cell.textLabel.text = @"Current Games";
            break;
        case 1:
            labelView.text = @"Start New Match";
            break;
        case 2:
            cell.textLabel.text = @"Login/Register";
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
        self.selectedIndex = indexPath;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        UIButton *buttonUkraine = (UIButton *) [cell viewWithTag:2];
        buttonUkraine.hidden = NO;
        UIButton *buttonPoland = (UIButton *) [cell viewWithTag:3];
        buttonPoland.hidden = NO;
    }
    else if (indexPath.row == 2) {
        self.selectedIndex = nil;
        [self.tableView reloadData];
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        self.selectedIndex = indexPath;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *buttonUkraine = (UIButton *) [cell viewWithTag:2];
        buttonUkraine.hidden = YES;
        UIButton *buttonPoland = (UIButton *) [cell viewWithTag:3];
        buttonPoland.hidden = YES;
    }
}

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

@end
