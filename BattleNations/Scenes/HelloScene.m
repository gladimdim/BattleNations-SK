//
//  HelloScene.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "HelloScene.h"
#import "GameLogic.h"
#import "Animator.h"
#import "DataPoster.h"

@interface HelloScene()
@property BOOL contentCreated;
@property int horizontalStep;
@property int verticalStep;

@property BOOL moving;
@property (strong) NSArray *unitWasSelectedPosition;

@property (strong) NSMutableArray *arrayOfStates;
@property BOOL bMyTurn;
@property NSString *currentPlayerID;
@property BOOL bankSelected;
@property NSString *unitNameSelectedInBank;
@property (strong) SKSpriteNode *selectedSprite;
@property (strong) GameDictProcessor *downloadedGameObj;
@property SKTextureAtlas *unitsAtlasUkraine;
@property SKTextureAtlas *unitsAtlasPoland;
@property GameLogic *gameLogic;

@end

@implementation HelloScene

-(HelloScene *) initWithSize:(CGSize)size gameObj:(NSDictionary *)gameObject {
    self = [super initWithSize:size];
    if (self) {
        self.gameObj = [[GameDictProcessor alloc] initWithDictOfGame:gameObject gameLogic:[[GameLogic alloc] initWithBoardSize:self.size]];
        self.downloadedGameObj = self.gameObj;
        self.arrayOfMoves = [NSMutableArray array];
        self.arrayOfStates = [NSMutableArray array];
        [self.arrayOfStates addObject:self.gameObj.dictOfGame];
        self.unitsAtlasUkraine = [SKTextureAtlas atlasNamed:@"ukraine_units"];
        self.unitsAtlasPoland = [SKTextureAtlas atlasNamed:@"poland_units"];
        self.gameLogic = [[GameLogic alloc] initWithBoardSize:size];
        
        [self setAnchorPoint:CGPointMake(0, 0)];
    }
    return self;
}

-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        //[self createScreenContents];
        self.contentCreated = YES;
    }
    [self initObject];
}

-(void) initObject {
    CGSize size = self.size;
    self.horizontalStep = floor(size.width / 9);
    self.verticalStep = floor(size.height / 6);
    NSLog(@"horizontal step: %i, vertical: %i", self.horizontalStep, self.verticalStep);
    self.currentPlayerID = [[NSUserDefaults standardUserDefaults] stringForKey:@"playerID"];
    self.bMyTurn = [self.gameObj isMyTurn:self.currentPlayerID];

    for (int i = 0; i < self.gameObj.arrayLeftField.count; i++) {
        [self placeUnit:self.gameObj.arrayLeftField[i] forLeftArmy:YES nationName:[self.gameObj.leftArmy valueForKey:@"nation" ]];
    }
    for (int i = 0; i < self.gameObj.arrayRightField.count; i++) {
        [self placeUnit:self.gameObj.arrayRightField[i] forLeftArmy:NO nationName:[self.gameObj.rightArmy valueForKey:@"nation"]];
    }
    
    //show bank units
    NSArray *arrayBank = [self.gameObj getArrayOfUnitNamesInBankForPlayerID:self.currentPlayerID];
    for (int i = 0; i < arrayBank.count; i++) {
        SKTextureAtlas *atlasToUse = [[self.gameObj nationForPlayerID:self.currentPlayerID] isEqualToString:@"ukraine"] ? self.unitsAtlasUkraine : self.unitsAtlasPoland;
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[atlasToUse textureNamed:[NSString stringWithFormat:@"%@_%@.png", [self.gameObj nationForPlayerID:self.currentPlayerID], arrayBank[i]]]];
        int xPos = 0;
       //  NSLog(@"sprite size: %@", NSStringFromCGSize(sprite.size));
        NSString *unitName = (NSString *) arrayBank[i];
        if ([unitName isEqualToString:@"infantry"]) {
            xPos = 0;
        }
        else if ([unitName isEqualToString:@"light_cavalry"]) {
            xPos = 1;
        }
        else if ([unitName isEqualToString:@"heavy_cavalry"]) {
            xPos = 2;
        }
        else if ([unitName isEqualToString:@"veteran"]) {
            xPos = 3;
        }
        else if ([unitName isEqualToString:@"healer"]) {
            xPos = 4;
        }
        else if ([unitName isEqualToString:@"super_unit"]) {
            xPos = 5;
        }
        
        NSArray *positionCoords = [NSArray arrayWithObjects:@(xPos), @(-1), nil];
        CGPoint position = [self.gameLogic gameToUIKitCoordinate:positionCoords];
        sprite.position = position;
        [self addChild:sprite];
    }
}

-(void) placeUnit:(NSDictionary *) unit forLeftArmy:(BOOL) leftArmy nationName:(NSString *) nationName {
    NSString *unitName = [unit allKeys][0];
    NSDictionary *unitDetails = [unit objectForKey:unitName];
    NSArray *position = [unitDetails objectForKey:@"position"];
    if (!position) {
        position = [NSArray arrayWithObjects:@(0), @(2), nil];
    }
    SKTextureAtlas *atlasToUse = [nationName isEqualToString:@"ukraine"] ? self.unitsAtlasUkraine : self.unitsAtlasPoland;
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[atlasToUse textureNamed:[NSString stringWithFormat:@"%@_%@.png", nationName, unitName]]];

    //SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@_%@.png", nationName, unitName]];
    if (!leftArmy) {
        [sprite setXScale:-1.0f];
    }
    CGPoint newPoint = [self.gameLogic gameToUIKitCoordinate:position];
    sprite.position = newPoint;
    [self addChild:sprite];
}

-(void) createScreenContents {
    self.backgroundColor = [UIColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
}

-(SKLabelNode *) newHelloNode {
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Hello Node";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return helloNode;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPointInView = [touch locationInNode:self];
    [self selectSpriteSquareAt:touchPointInView];
}

-(void) selectSpriteSquareAt:(CGPoint) touchPoint {
    NSLog(@"Entered select spriteSquare At point: %@", NSStringFromCGPoint(touchPoint));
    
    //find what sprite was touched
    SKSpriteNode *sprite = (SKSpriteNode *) [[self nodesAtPoint:touchPoint] firstObject];
    if (sprite) {
        [Animator animateSpriteDeselection:self.selectedSprite];
        self.selectedSprite = sprite;
    }
    //handle selection in bank
    if (touchPoint.y  < self.verticalStep) {
        NSLog(@"Handling selection in bank section");
        NSArray *pos = [self.gameLogic kitToGameCoordinate:touchPoint];
        int x = [pos[0] intValue];
        switch (x) {
            case 0:
                self.unitNameSelectedInBank = @"infantry";
                self.bankSelected = YES;
                break;
            case 1:
                self.unitNameSelectedInBank = @"light_cavalry";
                self.bankSelected = YES;
                break;
            case 2:
                self.unitNameSelectedInBank = @"heavy_cavalry";
                self.bankSelected = YES;
                break;
            case 3:
                self.unitNameSelectedInBank = @"veteran";
                self.bankSelected = YES;
                break;
            case 4:
                self.unitNameSelectedInBank = @"healer";
                self.bankSelected = YES;
                break;
            case 5:
                self.unitNameSelectedInBank = @"super_unit";
                self.bankSelected = YES;
                break;
            default:
                break;
        }
        self.unitWasSelectedPosition = nil;
        NSLog(@"Bank selection: %@", self.unitNameSelectedInBank);
        [Animator animateSpriteSelection:self.selectedSprite];
        return;
    }
    
    
    NSArray *positionOfSelectedUnit = [self.gameObj unitPresentAtPosition:touchPoint winSize:self.size horizontalStep:self.horizontalStep verticalStep:self.verticalStep currentPlayerID:self.currentPlayerID];
    //deselect if selected the same unit. Then return.
    if (positionOfSelectedUnit) {
        if ([self.unitWasSelectedPosition[0] integerValue] == [positionOfSelectedUnit[0] integerValue] && [self.unitWasSelectedPosition[1] integerValue] == [positionOfSelectedUnit[1] integerValue]) {
            self.unitWasSelectedPosition = nil;
            [Animator animateSpriteDeselection:self.selectedSprite];
            return;
        }
    }
    //if there are 6 states (5 + 1 because the initial position counts as state) already - return
    if (self.arrayOfStates.count >= 6) {
        NSLog(@"Movement denied: There are already 5 moves");
        return;
    }
    //if it is not our turn - return
    if (![self.gameObj isMyTurn:self.currentPlayerID]) {
        NSLog(@"Movement denied: it is not your turn");
        return;
    }
    
    [self makeMoveFromPosition:self.unitWasSelectedPosition touchedPoint:touchPoint forPlayerID:self.currentPlayerID];
    
}

-(void) makeMoveFromPosition:(NSArray *) initPosition touchedPoint:(CGPoint) touchPoint forPlayerID:(NSString *) playerID {
    
    NSArray *targetPosition = [self.gameObj unitPresentAtPosition:touchPoint winSize:self.size horizontalStep:self.horizontalStep verticalStep:self.verticalStep currentPlayerID:self.currentPlayerID];
    
    //attack or heal or deselect
    BOOL healerPresent = [self.gameLogic healerPresentAt:self.unitWasSelectedPosition forGame:self.gameObj forPlayerID:playerID];
    if (initPosition && targetPosition) {
        //friendly unit was selected on second touch
        //healing
        NSNumber *nFriendlyUnit = (NSNumber *) targetPosition[2];
        BOOL friendlyUnit = [nFriendlyUnit boolValue];
        if (friendlyUnit && healerPresent) {
            [Animator animateSpriteDeselection:self.selectedSprite];
            BOOL canHeal = [self.gameLogic canAttackFrom:initPosition to:targetPosition forPlayerID:playerID inGame:self.gameObj];
            if (canHeal) {
                NSDictionary *dictHealing = [self.gameLogic healUnitFrom:self.unitWasSelectedPosition fromPlayerID:playerID toUnit:targetPosition forGame:self.gameObj];
                NSLog(@"healed for: %@", [dictHealing objectForKey:@"healValue"]);
                NSNumber *healValue = [dictHealing objectForKey:@"healValue"];
                
                NSDictionary *newDictOfGame = [dictHealing objectForKey:@"dictOfGame"];
                if (newDictOfGame) {
                    GameDictProcessor *newGameObj = [[GameDictProcessor alloc] initWithDictOfGame:newDictOfGame gameLogic:self.gameLogic];
                    NSArray *arrayWithoutBool = @[initPosition[0], initPosition[1]];
                    [self.arrayOfMoves addObject:@[arrayWithoutBool, targetPosition]];
                    self.gameObj = newGameObj;
                    [self.arrayOfStates addObject:self.gameObj.dictOfGame];
                    [self removeAllChildren];
                    self.callBackBlockTurnMade(self.arrayOfMoves.count);
                    [self initObject];
                    self.unitNameSelectedInBank = nil;
                    self.unitWasSelectedPosition = nil;
                    //show label with heal value
                    if (healValue) {
                        SKLabelNode *labelHealing = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
                        labelHealing.fontColor = [UIColor greenColor];
                        labelHealing.fontSize = 20;
                        labelHealing.text = [NSString stringWithFormat:@"+%@", [healValue stringValue]];
                        CGPoint targetPoint = [self.gameLogic gameToUIKitCoordinate:targetPosition];
                        targetPoint.y = targetPoint.y + 30;
                        labelHealing.position = targetPoint;
                        [self addChild:labelHealing];
                        SKAction *actionScaleUp = [SKAction scaleTo:2.0f duration:0.5f];
                        SKAction *actionScaleDown = [SKAction scaleTo:1.0f duration:0.5f];
                        SKAction *sequence = [SKAction sequence:@[actionScaleUp, actionScaleDown]];
                        [labelHealing runAction:sequence completion:^(void) {
                            [labelHealing removeFromParent];
                        }];
                    }
                }
                else {
                    return;
                }
            }
            else {
                NSLog(@"Cannot attack.");
            }
        }
        //enemy unit was selected
        //attack if not healer
        else if (!healerPresent) {
            BOOL canAttack = [self.gameLogic canAttackFrom:initPosition to:targetPosition forPlayerID:playerID inGame:self.gameObj];
            if (canAttack) {
                NSDictionary *newDictOfGame = [self.gameLogic attackUnitFrom:initPosition fromPlayerID:playerID toUnit:targetPosition forGame:self.gameObj];
                if (newDictOfGame) {
                    GameDictProcessor *newGameObj = [[GameDictProcessor alloc] initWithDictOfGame:newDictOfGame gameLogic:self.gameLogic];
                    NSArray *arrayWithoutBool = @[initPosition[0], initPosition[1]];
                    [self.arrayOfMoves addObject:@[arrayWithoutBool, targetPosition]];
                    self.gameObj = newGameObj;
                    [self.arrayOfStates addObject:self.gameObj.dictOfGame];
                    [self removeAllChildren];
                    self.callBackBlockTurnMade(self.arrayOfMoves.count);
                    [self initObject];
                    self.unitNameSelectedInBank = nil;
                    self.unitWasSelectedPosition = nil;
                }
            }
            else {
                NSLog(@"Cannot attack.");
            }
            
        }
        self.unitWasSelectedPosition = nil;
    }
    //move
    else if (initPosition && !targetPosition) {
        for (int i = 0; i < self.children.count; i++) {
            //find old sprite which was selected
            SKSpriteNode *node = (SKSpriteNode *) [self.children objectAtIndex:i];
            NSLog(@"Checking node: %@", NSStringFromCGPoint(node.position));
            //calculate old CGPoint by using old game coordinates
            CGPoint oldPoint = CGPointMake([initPosition[0] integerValue] * self.horizontalStep + self.horizontalStep/2, [initPosition[1] integerValue] * self.verticalStep + self.verticalStep + self.verticalStep / 2);
            //calculate new position in game coordinates
            NSArray *newGameCoordinates = [self.gameLogic kitToGameCoordinate:touchPoint];
            if (CGRectContainsPoint(node.frame, oldPoint)) {
                NSLog(@"found sprite");
                if ([self.gameLogic canMoveFrom:initPosition to:newGameCoordinates forPlayerID:playerID inGame:self.gameObj]) {
                    SKAction *actionMove = [SKAction moveTo:[self.gameLogic gameToUIKitCoordinate:newGameCoordinates] duration:0.5f];
                    [node runAction:actionMove completion:^(void) {
                    //run animation of sprite's move. When animation is done - do necessary tasks to update gameObj with new coordinates.
                    //update gameObj dictionary with new position of unit
                    //add gameObj to arrayOfMoves
                    //this array contains initial position of unit and its target action;
                    //we need to add only coordinates to array of moves.
                    NSLog(@"Running animation for moving sprite");
                    NSArray *arrayWithoutBool = @[initPosition[0], initPosition[1]]; //@[self.unitWasSelectedPosition[0], self.unitWasSelectedPosition[1]];
                    NSArray *arrayOfPositionsInMove = @[arrayWithoutBool, newGameCoordinates];
                    NSDictionary *newDictOfGame = [self.gameLogic applyMove:arrayOfPositionsInMove toGame:self.gameObj forPlayerID:playerID];
                    self.gameObj = [[GameDictProcessor alloc] initWithDictOfGame:newDictOfGame gameLogic:self.gameLogic];
                    [self.arrayOfMoves addObject:arrayOfPositionsInMove];
                    [self.arrayOfStates addObject:self.gameObj.dictOfGame];
                    [self removeAllChildren];
                    self.callBackBlockTurnMade(self.arrayOfMoves.count);
                    [self initObject];
                    self.unitWasSelectedPosition = nil;
                    return;
                    }];
                }
                else {
                    NSLog(@"Denied movement of unit");
                    return;
                }
                
            }
        }
        self.unitWasSelectedPosition = nil;
    }
    
    //first selection
    else if (!self.unitWasSelectedPosition && targetPosition) {
        //remember only if friendly unit was selected;
        NSNumber *nFriendlyUnit = (NSNumber *) targetPosition[2];
        BOOL friendlyUnit = [nFriendlyUnit boolValue];
        if (friendlyUnit) {
            self.unitWasSelectedPosition = targetPosition;
            [Animator animateSpriteSelection:self.selectedSprite];
            NSArray *arr = [Animator createHealthBarsForFieldInGame:self.gameObj gameLogic:self.gameLogic];
            for (int i = 0; i < arr.count; i++) {
                [self addChild:arr[i]];
            }
        }
    }
    //placing new unit on board
    else if (self.bankSelected && !targetPosition) {
        NSArray *proposedPosition = [NSMutableArray arrayWithArray:[self.gameLogic kitToGameCoordinate:touchPoint]];
        [self placeNewUnitOnBoardForGame:self.gameObj unitName:self.unitNameSelectedInBank proposedPosition:proposedPosition forPlayerID:playerID];
    }
    
}

-(void) replayMoves {
    NSArray *arrayLastMoves = [NSMutableArray arrayWithArray:[self.gameObj arrayOfPreviousMoves]];
    GameDictProcessor *initialGameObj = [[GameDictProcessor alloc] initWithDictOfGame:[[self.downloadedGameObj initialTable] objectForKey:@"game"] gameLogic:self.gameLogic];
    self.gameObj = initialGameObj;
    [self removeAllChildren];
    [self initObject];
    
    [self makeMoveFromReplay:self.gameObj arrayOfMoves:[NSMutableArray arrayWithArray:arrayLastMoves]];
    
}

-(void) makeMoveFromReplay:(GameDictProcessor *) gameObject arrayOfMoves:(NSMutableArray *) arrayLastMoves {
    if (arrayLastMoves.count == 0) {
        self.unitNameSelectedInBank = nil;
        self.unitWasSelectedPosition = nil;
        self.bankSelected = NO;
        self.arrayOfMoves = [[NSMutableArray alloc] init];
        self.arrayOfStates = [[NSMutableArray alloc] init];
        [self.arrayOfStates addObject:self.downloadedGameObj.dictOfGame];
        [self removeAllChildren];
        self.gameObj = self.downloadedGameObj;
        [self initObject];
        return;
    }
    //move[0] contains always init position of unit
    //move[1] may contain array of destination position of unit, or string - name of unit to be placed at move[0]
    else {
        NSArray *move = [arrayLastMoves objectAtIndex:0];
        //if object is NSArray (not the string actually) - it means there are two arrays with coordinate, so it is move
        if ([move[1] isKindOfClass:[NSArray class]]) {
            //we need to rescan all sprite to find which sprite was selected.
            //THIS IS VERY IMPORTANT as without self.selectedSprite being correctly initialized animation does not work and CCCallBlocks are send to wrong instance (they are not
            //called at all).
            for (int i = 0; i < [self children].count; i++) {
                SKSpriteNode *sprite = (SKSpriteNode *) [[self children] objectAtIndex:i];
                if (CGRectContainsPoint([sprite frame], [self.gameLogic gameToUIKitCoordinate:move[0]])) {
                    [Animator animateSpriteDeselection:self.selectedSprite];
                    self.selectedSprite = sprite;
                }
            }
            
            NSLog(@"kuku");
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_current_queue(), ^(void){
                NSLog(@"Making move: %@", move);
                [self makeMoveFromPosition:move[0] touchedPoint:[self.gameLogic gameToUIKitCoordinate:move[1]] forPlayerID:[gameObject oppositePlayerID:self.currentPlayerID]];
                [arrayLastMoves removeObjectAtIndex:0];
                [self makeMoveFromReplay:self.gameObj arrayOfMoves:arrayLastMoves];
            });
        }
        //if second object in move is String - it means new unit was placed on board.
        else if ([move[1] isKindOfClass:[NSString class]]) {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"Making new board: %@", move);
                [self placeNewUnitOnBoardForGame:self.gameObj unitName:move[1] proposedPosition:move[0] forPlayerID:[self.gameObj oppositePlayerID:self.currentPlayerID]];
                [arrayLastMoves removeObjectAtIndex:0];
                [self makeMoveFromReplay:self.gameObj arrayOfMoves:arrayLastMoves];
            });
        }
    }
}

//places new unit on board from bank and creates new GameDictProcessor which is assigned to self
-(void) placeNewUnitOnBoardForGame:(GameDictProcessor *) gameObjLocal unitName:(NSString *) unitName proposedPosition:(NSArray *) proposedPositionFromCGPoint forPlayerID:(NSString *) playerID{
    if ([gameObjLocal checkBankQtyForPlayerID:playerID unit:unitName]) {
        NSLog(@"Placing new unit");
        //calculate if final destination is from two allowed positions for left/right player.
        NSSet *allowedCoordinates = [self.gameLogic getCoordinatesForNewUnitForGame:gameObjLocal forPlayerID:playerID];
        NSMutableArray *proposedPosition = [NSMutableArray arrayWithArray:proposedPositionFromCGPoint];
        if ([allowedCoordinates containsObject:proposedPosition]) {
            NSLog(@"Placing unit. Specified valid final coordinate.");
            NSDictionary *newDictOfGame = [self.gameLogic placeNewUnit:unitName forGame:gameObjLocal forPlayerID:playerID atPosition:proposedPosition];
            //pay attention that we add array with only one object - array of final destination
            //in future we will have to check if there is only one member in arrayOfMoves - it means we are placing new unit on board
            //////[proposedPosition addObject:self.unitNameSelectedInBank];
            [self.arrayOfMoves addObject:@[proposedPosition, unitName]];
            self.gameObj = [[GameDictProcessor alloc] initWithDictOfGame:newDictOfGame gameLogic:self.gameLogic];
            self.bankSelected = NO;
            //[self placeUnit:[UkraineInfo infantry] forLeftArmy:[[self.gameObj leftPlayerID] isEqualToString:self.currentPlayerID]  nationName:@"ukraine"];
            self.unitNameSelectedInBank = nil;
            [self.arrayOfStates addObject:self.gameObj.dictOfGame];
            [self removeAllChildren];
            self.callBackBlockTurnMade(self.arrayOfMoves.count);
            [self initObject];
        }
        else {
            NSLog(@"Placing unit failed: specified final coordinate which is not allowed.");
            return;
        }
    }
    else {
        NSLog(@"Not enough qty for unit %@", self.unitNameSelectedInBank);
        self.unitNameSelectedInBank = nil;
        self.unitWasSelectedPosition = NO;
    }
    
}

-(NSInteger) undoTurnAndReturnWhichTurn {
    if (self.arrayOfMoves.count == 0) {
        return 0;
    }
    else {
        [self.arrayOfMoves removeLastObject];
        [self.arrayOfStates removeLastObject];
        self.gameObj = [[GameDictProcessor alloc] initWithDictOfGame:[self.arrayOfStates lastObject] gameLogic:self.gameLogic];
        [self removeAllChildren];
        self.callBackBlockTurnMade(self.arrayOfMoves.count);
        [self initObject];
        return self.arrayOfMoves.count;
    }
}

-(void) sendGameToServer {
    if ([self.gameObj isMyTurn:self.currentPlayerID]) {
        DataPoster *poster = [[DataPoster alloc] init];
        [self.gameObj changeTurnToOtherPlayer];
        [poster sendMoves:self.arrayOfMoves forGame:self.gameObj withCallBack:^(BOOL success) {
            NSLog(@"Sent moves: %@", success ? @"YES" : @"NO");
        }];
    }
    else {
        NSLog(@"Sending denied: it is not your turn");
    }

}


@end
