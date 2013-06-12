//
//  UkraineInfo.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 4/27/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArmyBuilder.h"

@interface UkraineInfo : ArmyBuilder
-(NSDictionary *) infantry;
-(NSDictionary *) light_cavalry;
-(NSDictionary *) heavy_cavalry;
-(NSDictionary *) veteran;
-(NSDictionary *) healer;
-(NSDictionary *) super_unit;
@end
