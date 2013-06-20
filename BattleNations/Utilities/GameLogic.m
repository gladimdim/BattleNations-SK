//
//  GameLogic.m
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/23/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "GameLogic.h"
#import "ArmyBuilder.h"
#import "GameDictProcessor.h"

@interface GameLogic()
@property CGSize boardSize;
@end

@implementation GameLogic

-(GameLogic *) initWithBoardSize:(CGSize )boardSize {
    GameLogic *gameL = [[GameLogic alloc] init];
    gameL.boardSize = boardSize;
    gameL.horizontalStep = boardSize.width / 9;
    gameL.verticalStep = boardSize.height / 6;
    return gameL;
}

-(CGPoint) gameToUIKitCoordinate:(NSArray *) position {
    int x = [position[0] intValue] * [self horizontalStep];
    int y = [position[1] intValue] * [self verticalStep] + [self verticalStep];
    x = x + [self horizontalStep] /2;
    y = y + [self verticalStep] / 2;
    return CGPointMake(x, y);
}

-(NSArray *) kitToGameCoordinate:(CGPoint)position {
    NSInteger x = floor(position.x / [self horizontalStep]);
    NSInteger y = floor(position.y / [self verticalStep]) - 1;
    //we need to correct this as SpriteKit coordinates start from left top
    //y = 5 - y;
    NSArray *array = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:x], [NSNumber numberWithInteger:y], nil];
    return array;
}

/*

//returns updated gameObj. Moves unit from one pos to another
+(NSDictionary *) applyMove:(NSArray *) arrayOfActionsInMove toGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID {
    NSMutableDictionary *dictGame = [NSMutableDictionary dictionaryWithDictionary:gameObj.dictOfGame];
    NSMutableArray *field = [NSMutableArray arrayWithArray:[gameObj getFieldForPlayerID:playerID]];
    NSArray *initPosition = arrayOfActionsInMove[0];
    NSArray *targetPosition = arrayOfActionsInMove[1];
    for (int i = 0; i < field.count; i++) {
        NSString *unitName = [field[i] allKeys][0];
        NSMutableDictionary *unitDict = [NSMutableDictionary dictionaryWithDictionary:field[i]];
        NSMutableDictionary *unitDetails = [NSMutableDictionary dictionaryWithDictionary:[unitDict objectForKey:unitName]];
        NSMutableArray *position = [NSMutableArray arrayWithArray:[unitDetails objectForKey:@"position"]];
        if (position[0] == initPosition[0] && position[1] == initPosition[1])  {
            [unitDetails setObject:targetPosition forKey:@"position"];
            [unitDict setObject:unitDetails forKey:unitName];
            [field setObject:unitDict atIndexedSubscript:i];
//            leftField[i] = unitDict;
            NSMutableDictionary *armyDict = [NSMutableDictionary dictionaryWithDictionary:[dictGame objectForKey:playerID]];
            [armyDict setObject:field forKey:@"field"];
            [dictGame setObject:armyDict forKey:playerID];
            return dictGame;
        }
    }
    return [NSDictionary dictionaryWithDictionary:dictGame];
    
}

+(BOOL) canMoveFrom:(NSArray *) initPosition to:(NSArray *) destPosition forPlayerID:(NSString *) playerID inGame:(GameDictProcessor *) gameObj {
    NSDictionary *dictArmy = (NSDictionary *) [gameObj.dictOfGame objectForKey:playerID];
    if (dictArmy) {
        NSArray *field = (NSArray *) [dictArmy objectForKey:@"field"];
        for (int i = 0; i < field.count; i++) {
            NSDictionary *topUnit = (NSDictionary *) field[i];
            NSDictionary *unit = [topUnit objectForKey:[topUnit allKeys][0]];
            NSArray *position = (NSArray *) [unit objectForKey:@"position"];
            if (position[0] == initPosition[0] && position[1] == initPosition[1]) {
                NSInteger distance = abs([initPosition[0] integerValue] - [destPosition[0] integerValue]) + fabs( [initPosition[1] integerValue] - [destPosition[1] integerValue]);
                NSInteger rangeMove = [[unit valueForKey:@"range_move"] integerValue];
                return rangeMove >= distance;
            }
            else {
                continue;
            }
        }
    }
    return NO;
}

+(BOOL) canAttackFrom:(NSArray *) initPosition to:(NSArray *) destPosition forPlayerID:(NSString *) playerID inGame:(GameDictProcessor *) gameObj {
    NSDictionary *dictArmy = (NSDictionary *) [gameObj.dictOfGame objectForKey:playerID];
    if (dictArmy) {
        NSArray *field = (NSArray *) [dictArmy objectForKey:@"field"];
        for (int i = 0; i < field.count; i++) {
            NSDictionary *topUnit = (NSDictionary *) field[i];
            NSDictionary *unit = [topUnit objectForKey:[topUnit allKeys][0]];
            NSArray *position = (NSArray *) [unit objectForKey:@"position"];
            if (position[0] == initPosition[0] && position[1] == initPosition[1]) {
                NSInteger distance = abs([initPosition[0] integerValue] - [destPosition[0] integerValue]) + fabs( [initPosition[1] integerValue] - [destPosition[1] integerValue]);
                NSInteger meleeAttack = 1;
                //if it is possible to hit with melee attack - hit. If not - check for ranged attack.
                if (distance > meleeAttack) {
                    NSInteger rangeAttack = [[unit valueForKey:@"range_attack_length"] integerValue];
                    return rangeAttack >= distance;
                }
                else {
                    return YES;
                }
            }
            else {
                continue;
            }
        }
    }
    return NO;
}

+(NSDictionary *) placeNewUnit:(NSString *) unitName forGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID atPosition:(NSArray *) coords {
    NSMutableDictionary *dictBank = [NSMutableDictionary dictionaryWithDictionary:[gameObj getBankForPlayerID:playerID]];
    NSNumber *amountOfUnits = [dictBank objectForKey:unitName];
    amountOfUnits = [NSNumber numberWithInt:[amountOfUnits intValue] - 1];
    [dictBank setObject:amountOfUnits forKey:unitName];
    NSMutableDictionary *dictOfGame = [NSMutableDictionary dictionaryWithDictionary:gameObj.dictOfGame];
    NSMutableDictionary *dictPlayer = [NSMutableDictionary dictionaryWithDictionary:[dictOfGame objectForKey:playerID]];
    [dictPlayer setObject:dictBank forKey:@"bank"];
    NSMutableArray *fieldArray = [NSMutableArray arrayWithArray:[gameObj getFieldForPlayerID:playerID]];
    SEL s = NSSelectorFromString(unitName);
    ArmyBuilder *army = [[ArmyBuilder alloc] initWithNationsName:[gameObj nationForPlayerID:playerID]];
    NSMutableDictionary *dictNewUnit = [NSMutableDictionary dictionaryWithDictionary:[army performSelector:s]];
    NSMutableDictionary *dictNaked = [NSMutableDictionary dictionaryWithDictionary:[dictNewUnit objectForKey:unitName]];
    [dictNaked setObject:coords forKey:@"position"];
    //pack coordinates into new unit
    [dictNewUnit setObject:dictNaked forKey:unitName];
    
    //pack new unit into field
    [fieldArray addObject:dictNewUnit];
    //pack new field into player's dict
    [dictPlayer setObject:fieldArray forKey:@"field"];
    //pack new player dict into final dict
    [dictOfGame setObject:dictPlayer forKey:playerID];
    NSLog(@"placing new unit");
    return dictOfGame;
}

+(NSSet *) getCoordinatesForNewUnitForGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *) playerID {
    NSDictionary *dictOfGame = gameObj.dictOfGame;
    NSString *leftPlayer = [dictOfGame valueForKey:@"player_left"];
    if ([playerID isEqualToString:leftPlayer]) {
        return [NSSet setWithObjects:@[@(0), @(1)], @[@(0), @(3)], nil];
    }
    else {
        return [NSSet setWithObjects:@[@(8), @(1)], @[@(8), @(3)], nil];
    }
}

+(NSDictionary *) attackUnitFrom:(NSArray *) attackerCoords fromPlayerID:(NSString *) playerID toUnit:(NSArray *) targetCoords forGame:(GameDictProcessor *) gameObj {
    NSDictionary *dictOfAttacker = [NSDictionary dictionaryWithDictionary:[gameObj.dictOfGame objectForKey:playerID]];
    if (dictOfAttacker) {
        NSArray *field = (NSArray *) [dictOfAttacker objectForKey:@"field"];
        for (int i = 0; i < field.count; i++) {
            NSDictionary *topUnit = (NSDictionary *) field[i];
            NSDictionary *unit = [topUnit objectForKey:[topUnit allKeys][0]];
            NSArray *position = (NSArray *) [unit objectForKey:@"position"];
            if (position[0] == attackerCoords[0] && position[1] == attackerCoords[1]) {
                NSInteger damageValue = 0;
                NSInteger distance = abs([attackerCoords[0] integerValue] - [targetCoords[0] integerValue]) + fabs( [attackerCoords[1] integerValue] - [targetCoords[1] integerValue]);
                NSInteger meleeAttack = 1;
                //find the value of attacker's damage strength
                //melee attack
                if (distance == 1) {
                    damageValue = [[unit valueForKey:@"melee_attack_strength"] integerValue];
                }
                //ranged attack
                else {
                    damageValue = [[unit valueForKey:@"range_attack_strength"] integerValue];
                }
                //after damage value is found let's find target's unit and its health.
                //Then apply damage and pack dictionary back into dictOfGame and return it.
                
                //get target's playerID
                NSString *targetPlayerID = [[gameObj leftPlayerID] isEqualToString:playerID] ? [gameObj rightPlayerID] : [gameObj leftPlayerID];
                NSMutableDictionary *dictOfGame = [NSMutableDictionary dictionaryWithDictionary:gameObj.dictOfGame];
                NSMutableDictionary *dictPlayer = [NSMutableDictionary dictionaryWithDictionary:[dictOfGame objectForKey:targetPlayerID]];
                NSMutableArray *fieldArray = [NSMutableArray arrayWithArray:[gameObj getFieldForPlayerID:targetPlayerID]];
                
                for (int j = 0; j < fieldArray.count; j++) {
                    NSMutableDictionary *topUnit2 = [NSMutableDictionary dictionaryWithDictionary:fieldArray[j]];
                    NSMutableDictionary *unit2 = [NSMutableDictionary dictionaryWithDictionary:[topUnit2 objectForKey:[topUnit2 allKeys][0]]];
                    NSArray *position2 = (NSArray *) [unit2 objectForKey:@"position"];
                    if (position2[0] == targetCoords[0] && position2[1] == targetCoords[1]) {
                        NSInteger initHealth = [[unit2 valueForKey:@"level_life"] integerValue];
                        NSInteger finalHeath = initHealth - damageValue;
                        //the unit is killed. we need to delete it from fieldArray;
                        if (finalHeath <= 0) {
                            [fieldArray removeObjectAtIndex:j];
                            [dictPlayer setObject:fieldArray forKey:@"field"];
                            //pack new field into player's dict
                            [dictPlayer setObject:fieldArray forKey:@"field"];
                            //pack new player dict into final dict
                            [dictOfGame setObject:dictPlayer forKey:targetPlayerID];
                            NSLog(@"placing new unit");
                            return dictOfGame;

                        }
                        //the unit is wounded. we need to modify it's level_life and pack it back.
                        else {
                            [unit2 setObject:@(finalHeath) forKey:@"level_life"];
                            [topUnit2 setObject:unit2 forKey:[topUnit2 allKeys][0]];
                            [fieldArray removeObjectAtIndex:j];
                            [fieldArray addObject:topUnit2];
                            [dictPlayer setObject:fieldArray forKey:@"field"];
                            [dictOfGame setObject:dictPlayer forKey:targetPlayerID];
                            return dictOfGame;
                        }
////comment this block
                        //pack new unit into field
                        [fieldArray addObject:dictNewUnit];
                        //pack new field into player's dict
                        [dictPlayer setObject:fieldArray forKey:@"field"];
                        //pack new player dict into final dict
                        [dictOfGame setObject:dictPlayer forKey:targetPlayerID];
                        NSLog(@"placing new unit");
 ////////comment this block

                    }
                }
                
                
                
            }
        }
    }
    return nil;
}

+(NSDictionary *) healUnitFrom:(NSArray *) healerCoords fromPlayerID:(NSString *) playerID toUnit:(NSArray *) targetCoords forGame:(GameDictProcessor *) gameObj {
    NSDictionary *dictOfHealer = [NSDictionary dictionaryWithDictionary:[gameObj.dictOfGame objectForKey:playerID]];
    if (dictOfHealer) {
        NSArray *field = (NSArray *) [dictOfHealer objectForKey:@"field"];
        for (int i = 0; i < field.count; i++) {
            NSDictionary *topUnit = (NSDictionary *) field[i];
            NSDictionary *unit = [topUnit objectForKey:[topUnit allKeys][0]];
            NSArray *position = (NSArray *) [unit objectForKey:@"position"];
            if (position[0] == healerCoords[0] && position[1] == healerCoords[1]) {
                NSInteger healValue = [unit valueForKey:@"heal"];

                NSMutableDictionary *dictOfGame = [NSMutableDictionary dictionaryWithDictionary:gameObj.dictOfGame];
                NSMutableDictionary *dictPlayer = [NSMutableDictionary dictionaryWithDictionary:[dictOfGame objectForKey:playerID]];
                NSMutableArray *fieldArray = [NSMutableArray arrayWithArray:[gameObj getFieldForPlayerID:playerID]];
                
                for (int j = 0; j < fieldArray.count; j++) {
                    NSMutableDictionary *topUnit2 = [NSMutableDictionary dictionaryWithDictionary:fieldArray[j]];
                    NSMutableDictionary *unit2 = [NSMutableDictionary dictionaryWithDictionary:[topUnit2 objectForKey:[topUnit2 allKeys][0]]];
                    NSArray *position2 = (NSArray *) [unit2 objectForKey:@"position"];
                    if (position2[0] == targetCoords[0] && position2[1] == targetCoords[1]) {
                        NSInteger initHealth = [[unit2 valueForKey:@"level_life"] integerValue];
                        NSInteger finalHeath = initHealth + healValue > 100 ? 100 : initHealth + healValue;
                        [unit2 setObject:@(finalHeath) forKey:@"level_life"];
                        [topUnit2 setObject:unit2 forKey:[topUnit2 allKeys][0]];
                        [fieldArray removeObjectAtIndex:j];
                        [fieldArray addObject:topUnit2];
                        [dictPlayer setObject:fieldArray forKey:@"field"];
                        [dictOfGame setObject:dictPlayer forKey:playerID];
                        return dictOfGame;
                    }
                }
            }
        }
    }
    return nil;
}

//returns true if healer is present at specified coordinates for specified playerID
//in future can be abstracted to check for any unit name.
+(BOOL) healerPresentAt:(NSArray *) position forGame:(GameDictProcessor *) gameObj forPlayerID:(NSString *)playerId {
    NSArray *field = [gameObj getFieldForPlayerID:playerId];
    for (int i = 0; i < field.count; i++) {
        NSDictionary *topUnit = (NSDictionary *) field[i];
        NSString *unitName = (NSString *) [topUnit allKeys] [0];
        NSDictionary *unit = [topUnit objectForKey:[topUnit allKeys][0]];
        NSArray *positionOfUnit = (NSArray *) [unit objectForKey:@"position"];
        if (position[0] == positionOfUnit[0] && positionOfUnit[1] == positionOfUnit[1]) {
            if ([unitName isEqualToString:@"healer"]) {
                return true;
            }
        }
    }
    return false;
}*/

@end
