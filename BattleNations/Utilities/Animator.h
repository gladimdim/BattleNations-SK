//
//  Animator.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 5/11/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDictProcessor.h"
#import <SpriteKit/SpriteKit.h>
#import "GameLogic.h"

@interface Animator : NSObject
+(void) animateSpriteSelection:(SKSpriteNode *) sprite;
+(void) animateSpriteDeselection:(SKSpriteNode *) sprite;
+(NSArray *) createHealthBarsForFieldInGame:(GameDictProcessor *) gameObj gameLogic:(GameLogic *) gameLogic;
+(void) animateSpriteAttack:(SKSpriteNode *) sprite;
@end
