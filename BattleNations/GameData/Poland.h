//
//  Poland.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 4/30/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArmyBuilder.h"

@interface Poland : ArmyBuilder
-(NSDictionary *) infantry;
-(NSDictionary *) light_cavalry;
-(NSDictionary *) heavy_cavalry;
-(NSDictionary *) veteran;
-(NSDictionary *) healer;
-(NSDictionary *) super_unit;
@end
