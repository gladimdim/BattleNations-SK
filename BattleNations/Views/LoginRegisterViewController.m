//
//  LoginRegisterViewController.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/16/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "UserRegister.h"

@interface LoginRegisterViewController ()
- (IBAction)btnRegisterPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation LoginRegisterViewController

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

- (IBAction)btnRegisterPressed:(id)sender {
    if ([self.textFieldUsername.text isEqualToString:@""] || [self.textFieldPassword.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Enter username and password", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UserRegister *userReg = [[UserRegister alloc] init];
        [userReg registerUser:self.textFieldUsername.text withEmail:self.textFieldPassword.text deviceToken:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"] callBack:^(NSDictionary * message, NSError *err) {
            if (err) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error occurred", nil) message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            NSLog(@"succesfully registered: %@", message);
            NSString *result = [message objectForKey:@"result"];
            
            if ([result isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.textFieldUsername.text forKey:@"playerID"];
                [[NSUserDefaults standardUserDefaults] setObject:self.textFieldPassword.text forKey:@"email"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
@end
