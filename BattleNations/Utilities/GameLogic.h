//
//  GameLogic.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/23/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  GameDictProcessor;

@interface GameLogic : NSObject
-(GameLogic *) initWithBoardSize:(CGSize) boardSize;
-(CGPoint) gameToUIKitCoordinate:(NSArray *) position;

-(NSArray *) kitToGameCoordinate:(CGPoint) position;

-(NSDictionary *) applyMove:(NSArray *) arrayOfActionsInMove toGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID;
-(BOOL) canMoveFrom:(NSArray *) initPosition to:(NSArray *) destPosition forPlayerID:(NSString *) playerID inGame:(GameDictProcessor *) gameObj;
-(BOOL) canAttackFrom:(NSArray *) initPosition to:(NSArray *) destPosition forPlayerID:(NSString *) playerID inGame:(GameDictProcessor *) gameObj;

-(NSDictionary *) placeNewUnit:(NSString *) unitName forGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID atPosition:(NSArray *) coords;
-(NSSet *) getCoordinatesForNewUnitForGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID;
-(NSDictionary *) attackUnitFrom:(NSArray *) attackerCoords fromPlayerID:(NSString *) playerID toUnit:(NSArray *) targetCoords forGame:(GameDictProcessor *) gameObj;
-(NSDictionary *) healUnitFrom:(NSArray *) healerCoords fromPlayerID:(NSString *) playerID toUnit:(NSArray *) targetCoords forGame:(GameDictProcessor *) gameObj;
 
@property int horizontalStep;
@property int verticalStep;

-(BOOL) healerPresentAt:(NSArray *) position forGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID;
+(NSDictionary *) initPlayerInGameWithNation:(NSString *) nationName forDictOfGame:(NSDictionary *) dictOfGame;
@end
