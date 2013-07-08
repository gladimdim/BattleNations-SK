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

+(NSDictionary *) buildBankForNation:(NSString *) nationName {
    NSMutableDictionary *dictBank = [NSMutableDictionary dictionary];
    if ([nationName isEqualToString:@"ukraine"]) {
        return dictBank = [NSMutableDictionary dictionaryWithDictionary:[UkraineInfo initForBank]];
    }
    else if ([nationName isEqualToString:@"poland"]) {
        return dictBank = [NSMutableDictionary dictionaryWithDictionary:[Poland initForBank]];
    }
    else {
        return nil;
    }
}
@end
