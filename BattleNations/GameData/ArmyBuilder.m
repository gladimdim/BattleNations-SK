//
//  ArmyBuilder.m
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 4/30/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "ArmyBuilder.h"
#import "UkraineInfo.h"
#import "Poland.h"
@implementation ArmyBuilder
-(ArmyBuilder *) initWithNationsName:(NSString *)nationName {
    if ([nationName isEqualToString:@"ukraine"]) {
        return [[UkraineInfo alloc] init];
    }
    else if ([nationName isEqualToString:@"poland"]) {
        return [[Poland alloc] init];
    }
    else {
        return nil;
    }
}
@end
