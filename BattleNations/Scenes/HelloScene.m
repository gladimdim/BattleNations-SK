//
//  HelloScene.m
//  BattleNations
//
//  Created by Dmytro Gladkyi on 6/12/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "HelloScene.h"

@interface HelloScene()
@property BOOL contentCreated;
@end

@implementation HelloScene
-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createScreenContents];
        self.contentCreated = YES;
    }
}

-(void) createScreenContents {
    self.backgroundColor = [UIColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self newHelloNode]];
}

-(SKLabelNode *) newHelloNode {
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Hello Node";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return helloNode;
}
@end
