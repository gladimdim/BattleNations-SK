//
//  GameDictProcessor.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/18/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLogic.h"
@interface GameDictProcessor : NSObject

/*-(NSDictionary *) getLeftArmy;
-(NSDictionary *) getRightArmy;
-(NSArray *) getLeftField;
-(NSArray *) getRightField;*/
@property (strong) NSDictionary *dictOfGame;
@property (strong) NSDictionary *leftArmy;
@property (strong) NSDictionary *rightArmy;
@property (strong) NSArray *arrayLeftField;
@property (strong) NSArray *arrayRightField;
@property (strong) NSArray *leftBank;
@property (strong) NSArray *rightBank;

-(GameDictProcessor *) initWithDictOfGame:(NSDictionary *) dictOfGame gameLogic:(GameLogic *) gameLog;

-(NSArray *) unitPresentAtPosition:(CGPoint ) spritePoint winSize:(CGSize) winSize horizontalStep:(int) hStep verticalStep:(int) vStep currentPlayerID:(NSString *) playerID;
-(NSString *) leftPlayerID;
-(NSString *) rightPlayerID;
-(BOOL) isMyTurn:(NSString *) playerID;
-(NSString *) getGameID;
-(void) changeTurnToOtherPlayer;
-(NSArray *) getArrayOfUnitNamesInBankForPlayerID:(NSString *) playerID;
-(NSDictionary *) getBankForPlayerID:(NSString *) playerID;
-(NSArray *) getFieldForPlayerID:(NSString *) playerID;
-(BOOL) checkBankQtyForPlayerID:(NSString *) playerID unit:(NSString *) unit;
-(NSString *) nationForPlayerID:(NSString *) playerID;
-(NSInteger) getHealthLevelForUnit:(NSDictionary *) unitDict;
-(NSArray *) getCoordsForUnit:(NSDictionary *) unitDict;
-(NSDictionary *) initialTable;
-(NSArray *) arrayOfPreviousMoves;
-(NSString *) oppositePlayerID:(NSString *) currentPlayerID;
-(UIImage *) imageForLeftPlayersNation;
-(UIImage *) imageForRightPlayersNation;



@end
