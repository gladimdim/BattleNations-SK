//
//  DataPoster.h
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/31/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDictProcessor.h"
@interface DataPoster : NSObject <NSURLConnectionDelegate>
-(void) sendMoves:(NSArray *) arrayOfMoves forGame:(GameDictProcessor*) gameObj withCallBack:(void (^) (BOOL)) callBackBlock;
@end
