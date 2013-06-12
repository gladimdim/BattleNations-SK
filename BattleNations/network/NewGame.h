//
//  NewGame.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 5/4/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewGame : NSObject <NSURLConnectionDelegate>
-(void) askForNewGameForUser:(NSString *) username withEmail:(NSString *) email forNation:(NSString *) nation callBack:(void (^) (NSDictionary *, NSError *)) callBackBlock;
@end
