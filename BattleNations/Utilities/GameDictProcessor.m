//
//  GameDictProcessor.m
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/18/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "GameDictProcessor.h"

@interface GameDictProcessor()
//@property NSDictionary *dictOfGame
@property GameLogic * gameLogic;
@end

@implementation GameDictProcessor

-(GameDictProcessor *) initWithDictOfGame:(NSDictionary *) dictOfGame gameLogic:(GameLogic *) gameL {
    GameDictProcessor *game = [[GameDictProcessor alloc] init];
    game.gameLogic = gameL;
    if (dictOfGame) {
        game.dictOfGame = dictOfGame;
        NSString *leftArmyPlayerID = [game.dictOfGame valueForKey:@"player_left"];
        game.leftArmy = [game.dictOfGame objectForKey:leftArmyPlayerID];
        NSString *rightArmyPlayerID = [game.dictOfGame valueForKey:@"player_right"];
        game.rightArmy = [game.dictOfGame objectForKey:rightArmyPlayerID];
        game.arrayLeftField = [game.leftArmy objectForKey:@"field"];
        game.arrayRightField = [game.rightArmy objectForKey:@"field"];
    }
    return game;
}

//checks if touched point contains friendly/enemy unit.
//Returns array with three objects: first two are game coordinates, the third one is NSNumber with bool value. BOOL represents if friendly unit was selected.
-(NSArray *) unitPresentAtPosition:(CGPoint ) spritePoint winSize:(CGSize) winSize horizontalStep:(int) hStep verticalStep:(int) vStep currentPlayerID:(NSString *) playerID {
    
    NSArray *gameCoordinates = [self.gameLogic kitToGameCoordinate:spritePoint];
    NSUInteger x = [gameCoordinates[0] integerValue]; //floor(spritePoint.x / hStep);
    NSUInteger y = [gameCoordinates[1] integerValue]; //floor(spritePoint.y / vStep) - 1;
    NSLog(@"unitPresentAtPos x: %i, y: %i", x, y);
    for (int i = 0; i < self.arrayLeftField.count; i++) {
        NSString *unitName = [self.arrayLeftField[i] allKeys][0];
        NSDictionary *unitDetails = [self.arrayLeftField[i] objectForKey:unitName];
        NSArray *position = [unitDetails objectForKey:@"position"];
        NSUInteger posX = (NSUInteger) [position[0] integerValue];
        NSUInteger posY = (NSUInteger) [position[1] integerValue];
        if (posX == x && posY == y) {
            BOOL friendlyUnit = [[self.dictOfGame valueForKey:@"player_left"] isEqualToString:playerID];
            NSMutableArray *arrayToReturn = [NSMutableArray arrayWithArray:position];
            [arrayToReturn addObject:[NSNumber numberWithBool:friendlyUnit]];
            //[arrayToReturn addObject:unitName];
            return arrayToReturn;
        }
    }
    for (int i = 0; i < self.arrayRightField.count; i++) {
        NSString *unitName = [self.arrayRightField[i] allKeys][0];
        NSDictionary *unitDetails = [self.arrayRightField[i] objectForKey:unitName];
        NSArray *position = [unitDetails objectForKey:@"position"];
        NSUInteger posX = (NSUInteger) [position[0] integerValue];
        NSUInteger posY = (NSUInteger) [position[1] integerValue];
        if (posX == x && posY == y) {
            BOOL friendlyUnit = [[self.dictOfGame valueForKey:@"player_right"] isEqualToString:playerID];
            NSMutableArray *arrayToReturn = [NSMutableArray arrayWithArray:position];
            [arrayToReturn addObject:[NSNumber numberWithBool:friendlyUnit]];
            //[arrayToReturn addObject:unitName];
            return arrayToReturn;
        }
    }
    return nil;
}
/*
-(BOOL) isMyTurn:(NSString *) playerID {
    BOOL leftPlayerTurn = [[NSNumber numberWithInt:[[self.dictOfGame valueForKey:@"left_army_turn"] integerValue]] boolValue]; //[[self.gameObj.dictOfGame valueForKey:@"left_army_turn"] isEqualToString:@"true"] ? YES: NO;
    if ([playerID isEqualToString:[self.dictOfGame valueForKey:@"player_left"]] && leftPlayerTurn) {
        return YES;
    }
    else if ([playerID isEqualToString:[self.dictOfGame valueForKey:@"player_right"]] && !leftPlayerTurn) {
        return YES;
    }
    return NO;
}*/

-(NSString *) getGameID {
    return [self.dictOfGame valueForKey:@"game_id"];
}

/*
//changes "left_army_turn" to true or false depending on which site of deck current user is
-(void) changeTurnToOtherPlayer {
    if ([self isMyTurn:[[NSUserDefaults standardUserDefaults] stringForKey:@"playerID"]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dictOfGame];
//        [dict setValue:NO forKey:@"left_army_turn"];
        BOOL leftPlayerTurn = [[NSNumber numberWithInt:[[self.dictOfGame valueForKey:@"left_army_turn"] integerValue]] boolValue];
        [dict setValue:[NSNumber numberWithBool:!leftPlayerTurn] forKey:@"left_army_turn"];
        self.dictOfGame = [NSDictionary dictionaryWithDictionary:dict];
    }
}*/

-(NSArray *) getArrayOfUnitNamesInBankForPlayerID:(NSString *) playerID {
    NSDictionary *playerDict = [self.dictOfGame objectForKey:playerID];
    NSDictionary *dictOfBankUnits = [playerDict objectForKey:@"bank"];
    return [dictOfBankUnits allKeys];
}

-(NSDictionary *) getBankForPlayerID:(NSString *) playerID {
    NSDictionary *playerDict = [self.dictOfGame objectForKey:playerID];
    return [playerDict objectForKey:@"bank"];
}

-(NSString *) leftPlayerID {
    return [self.dictOfGame valueForKey:@"player_left"];
}

-(NSString *) rightPlayerID {
    return [self.dictOfGame valueForKey:@"player_right"];
}

-(NSArray *) getFieldForPlayerID:(NSString *) playerID {
    NSDictionary *dict = [self.dictOfGame objectForKey:playerID];
    NSArray *array = [dict objectForKey:@"field"];
    return array;
}

-(BOOL) checkBankQtyForPlayerID:(NSString *) playerID unit:(NSString *) unit {
    NSDictionary *bank = [self getBankForPlayerID:playerID];
    int amount = [[bank objectForKey:unit] intValue];
    return amount > 0;
}

-(NSString *) nationForPlayerID:(NSString *) playerID {
    NSDictionary *dictPlayer = [self.dictOfGame objectForKey:playerID];
    return [dictPlayer valueForKey:@"nation"];
}

-(NSInteger) getHealthLevelForUnit:(NSDictionary *) unitDict {
    NSDictionary *dict = [unitDict objectForKey:[unitDict allKeys][0]];
    return [[dict valueForKey:@"level_life"] integerValue];
}

-(NSArray *) getCoordsForUnit:(NSDictionary *) unitDict {
    NSDictionary *dict = [unitDict objectForKey:[unitDict allKeys][0]];
    return (NSArray *) [dict objectForKey:@"position"];
}

-(NSDictionary *) initialTable {
    return (NSDictionary *) [self.dictOfGame objectForKey:@"initialTable"];
}

-(NSArray *) arrayOfPreviousMoves {
    return (NSArray *) [self.dictOfGame objectForKey:@"lastMoves"];
}

-(NSString *) oppositePlayerID:(NSString *) currentPlayerID {
   return [[self leftPlayerID] isEqualToString:currentPlayerID] ? [self rightPlayerID] : [self leftPlayerID];
}

-(UIImage *) imageForLeftPlayersNation {
    NSDictionary *dictPlayer = [self.dictOfGame objectForKey:[self leftPlayerID]];
    NSString *nation = [dictPlayer valueForKey:@"nation"];
    return [UIImage imageNamed:[NSString stringWithFormat:@"flag_%@", nation]];
}

-(UIImage *) imageForRightPlayersNation {
    NSDictionary *dictPlayer = [self.dictOfGame objectForKey:[self rightPlayerID]];
    NSString *nation = [dictPlayer valueForKey:@"nation"];
    return [UIImage imageNamed:[NSString stringWithFormat:@"flag_%@", nation]];
}

@end
