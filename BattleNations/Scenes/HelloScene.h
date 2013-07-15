//
//  HelloScene.h
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameDictProcessor.h"
#import <GameKit/GameKit.h>

@interface HelloScene : SKScene

-(HelloScene *) initWithSize:(CGSize) size dictOfGame:(NSDictionary *) dictOfGame;
-(NSInteger) undoTurnAndReturnWhichTurn;
@property (copy, nonatomic) void (^callBackBlockTurnMade) (NSInteger);
@property (copy, nonatomic) void (^callBackBlockReplayTurnMade) (NSInteger);
@property NSMutableArray *arrayOfMoves;
@property GKTurnBasedMatch *match;
@property GameDictProcessor *gameObj;
@property (strong) GameDictProcessor *downloadedGameObj;
-(void) replayMoves;
@end
