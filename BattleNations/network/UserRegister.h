//
//  UserRegister.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 4/16/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRegister : NSObject <NSURLConnectionDelegate>
-(void) registerUser:(NSString *) username withEmail:(NSString *) email deviceToken:(NSString *) deviceToken callBack:(void (^) (NSDictionary *, NSError *)) callBackBlock;
@end
