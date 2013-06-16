//
//  HelloScene.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "HelloScene.h"
#import "GameLogic.h"
#import "GameDictProcessor.h"
@interface HelloScene()
@property BOOL contentCreated;
@property int horizontalStep;
@property int verticalStep;
@property (strong) GameDictProcessor *gameObj;
@property CGPoint lastTouchedPoint;
@property BOOL moving;
@property (strong) NSArray *unitWasSelectedPosition;
@property NSMutableArray *arrayOfMoves;
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
        NSData * data = [NSPropertyListSerialization dataFromPropertyList:self.gameObj.dictOfGame
                                                                   format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
        NSLog(@"size: %d", [data length]);
        self.unitsAtlasUkraine = [SKTextureAtlas atlasNamed:@"ukraine_units"];
        self.unitsAtlasPoland = [SKTextureAtlas atlasNamed:@"poland_units"];
        self.gameLogic = [[GameLogic alloc] initWithBoardSize:self.size];
    }
    return self;
}

-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createScreenContents];
        self.contentCreated = YES;
    }
    [self initObject];
}

-(void) initObject {
    CGSize size = self.frame.size;
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
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[atlasToUse textureNamed:[NSString stringWithFormat:@"%@_%@.png", [self.gameObj nationForPlayerID:self.currentPlayerID], unitName]]];

    //SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@_%@.png", nationName, unitName]];
    if (!leftArmy) {
        //[sprite setScaleX:-1.0];
        [sprite setZRotation:180];
    }
    CGPoint newPoint = [self.gameLogic gameToUIKitCoordinate:position];
  //  NSLog(@"placing sprite at %@ [%@]", NSStringFromCGPoint(newPoint), position);
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
    //NSLog(@"%@", touches);
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:self.view];
        NSLog(@"location: %@", NSStringFromCGPoint(touchPoint));
        NSArray *array = [self.gameObj unitPresentAtPosition:touchPoint winSize:self.view.frame.size horizontalStep:self.gameLogic.horizontalStep verticalStep:self.gameLogic.verticalStep currentPlayerID:self.currentPlayerID];
        NSLog(@"array: %@", array);
    }
}

@end
