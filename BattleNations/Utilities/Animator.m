//
//  Animator.m
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 5/11/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "Animator.h"
#import "GameLogic.h"

@implementation Animator
+(void) animateSpriteSelection:(SKSpriteNode *)sprite {
    SKAction *action = [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:0.8f duration:0.5];
    [sprite runAction:action];
}

+(void) animateSpriteDeselection:(SKSpriteNode *)sprite {
    [sprite setColorBlendFactor:0.0f];
}

+(NSArray *) createHealthBarsForFieldInGame:(GameDictProcessor *) gameObj gameLogic:(GameLogic *)gameLogic {
    NSArray *arrayOfAllFields = [gameObj.arrayLeftField arrayByAddingObjectsFromArray:gameObj.arrayRightField];
    NSMutableArray *arrayOfHealthSprites = [[NSMutableArray alloc] initWithCapacity:arrayOfAllFields.count];
    for (int i = 0; i < arrayOfAllFields.count; i++) {
        NSInteger health =  [gameObj getHealthLevelForUnit:arrayOfAllFields[i]];
       
        SKLabelNode *labelHealth = [SKLabelNode labelNodeWithFontNamed:@"Arial Bold"];
        labelHealth.text = [NSString stringWithFormat:@"Health :%i", health];
        labelHealth.blendMode = SKBlendModeReplace;
        labelHealth.fontColor = [UIColor whiteColor];
        labelHealth.fontSize = 10.0;
        labelHealth.color = [UIColor redColor];
        labelHealth.colorBlendFactor = (100.0 - health) / 100.0;
        NSArray *coords = [gameObj getCoordsForUnit:arrayOfAllFields[i]];
        CGPoint centerPosition = [gameLogic gameToUIKitCoordinate:coords];
        centerPosition.y = centerPosition.y + [gameLogic verticalStep] / 2 + 10;
        labelHealth.position = centerPosition;
        [arrayOfHealthSprites addObject:labelHealth];
    }
    return arrayOfHealthSprites;
}

+(void) animateSpriteAttack:(SKSpriteNode *) sprite {
    NSMutableArray *frames = [NSMutableArray array];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ukraine_infantry"];
    for (int i = 1; i < 9; i++) {
        NSString *filename = [NSString stringWithFormat:@"attack_00%i.png", i];
        SKTexture *texture = [atlas textureNamed:filename];
        [frames addObject:texture];
    }
    SKAction *action = [SKAction animateWithTextures:frames timePerFrame:0.2];
    [sprite runAction:action];
}

@end
