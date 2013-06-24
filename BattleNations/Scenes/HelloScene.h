//
//  HelloScene.h
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HelloScene : SKScene

-(HelloScene *) initWithSize:(CGSize) size gameObj:(NSDictionary *) gameObject;
-(NSInteger) undoTurnAndReturnWhichTurn;
-(NSInteger) madeTurnNumber;
@property (copy, nonatomic) void (^callBackBlockTurnMade) (NSInteger);
-(void) sendGameToServer;
@end
