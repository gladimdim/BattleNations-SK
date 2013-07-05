//
//  BNViewController.h
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface GameBoardViewController : UIViewController
@property NSDictionary *dictOfGame;
@property GKMatch *match;
@end
