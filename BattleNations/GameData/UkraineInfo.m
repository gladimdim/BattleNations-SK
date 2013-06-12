//
//  UkraineInfo.m
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 4/27/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "UkraineInfo.h"

@implementation UkraineInfo
-(NSDictionary *) infantry {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@(100), @(3), @(30), @(1), @(20)] forKeys:@[@"level_life", @"range_attack_length", @"range_attack_strength", @"range_move", @"melee_attack_strength"]];
    NSDictionary *dictToReturn = [NSDictionary dictionaryWithObject:dict forKey:@"infantry"];
    return dictToReturn;
}
-(NSDictionary *) light_cavalry {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@(100), @(0), @(0), @(3), @(30)] forKeys:@[@"level_life", @"range_attack_length", @"range_attack_strength", @"range_move", @"melee_attack_strength"]];
    NSDictionary *dictToReturn = [NSDictionary dictionaryWithObject:dict forKey:@"light_cavalry"];
    return dictToReturn;
}

-(NSDictionary *) veteran {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@(100), @(3), @(40), @(2), @(25)] forKeys:@[@"level_life", @"range_attack_length", @"range_attack_strength", @"range_move", @"melee_attack_strength"]];
    NSDictionary *dictToReturn = [NSDictionary dictionaryWithObject:dict forKey:@"veteran"];
    return dictToReturn;
}

-(NSDictionary *) healer {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@(100), @(3), @(2), @(35)] forKeys:@[@"level_life", @"range_move", @"range_attack_length", @"heal"]];
    NSDictionary *dictToReturn = [NSDictionary dictionaryWithObject:dict forKey:@"healer"];
    return dictToReturn;
}

-(NSDictionary *) super_unit {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@(100), @(0), @(0), @(3), @(40)] forKeys:@[@"level_life", @"range_attack_length", @"range_attack_strength", @"range_move", @"melee_attack_strength"]];
    NSDictionary *dictToReturn = [NSDictionary dictionaryWithObject:dict forKey:@"super_unit"];
    return dictToReturn;
}

@end
