//
//  ListOfGamesGetter.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/16/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListOfGamesGetter : NSObject <NSURLConnectionDelegate>
-(void) getListOfGamesFor:(NSString *) playerID withCallBack:(void (^) (NSDictionary *, NSError *)) callBackBlock;
@end
