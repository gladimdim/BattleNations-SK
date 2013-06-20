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

/*
+(NSArray *) createHealthBarsForFieldInGame:(GameDictProcessor *) gameObj {
    NSArray *arrayOfAllFields = [gameObj.arrayLeftField arrayByAddingObjectsFromArray:gameObj.arrayRightField];
    NSMutableArray *arrayOfHealthSprites = [[NSMutableArray alloc] initWithCapacity:arrayOfAllFields.count];
    for (int i = 0; i < arrayOfAllFields.count; i++) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Health-Bar.plist"];
        NSInteger health =  [gameObj getHealthLevelForUnit:arrayOfAllFields[i]];
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:health > 50 ? @"health-bar-100.png" : @"health-bar-20.png"];
        NSArray *coords = [gameObj getCoordsForUnit:arrayOfAllFields[i]];
        CGPoint centerPosition = [GameLogic gameToCocosCoordinate:coords];
        centerPosition.y = centerPosition.y + [GameLogic verticalStep] / 2;
        sprite.position = centerPosition;
        [arrayOfHealthSprites addObject:sprite];
    }
    return arrayOfHealthSprites;
}*/

@end
