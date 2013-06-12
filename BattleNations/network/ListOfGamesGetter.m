//
//  ListOfGamesGetter.m
//  Battle-Nations-XVII
//
//  Created by Dmytro Gladkyi on 3/16/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "ListOfGamesGetter.h"

@interface ListOfGamesGetter()
@property (copy, nonatomic) void (^callBackBlock) (NSDictionary *, NSError *);
@property NSMutableData *receivedData;
@end

@implementation ListOfGamesGetter
-(void) getListOfGamesFor:(NSString *) playerID withCallBack:(void (^) (NSDictionary *, NSError *)) callBackBlock {
    self.callBackBlock = callBackBlock;
    NSString *server = [[NSUserDefaults standardUserDefaults] stringForKey:@"server"];
    NSString *port = [[NSUserDefaults standardUserDefaults] stringForKey:@"port"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@/get-game", server, port]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:playerID forKey:@"player-id"];
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONReadingAllowFragments error:&err];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
 /*   NSLog(@"request: %@", request);
    NSLog(@"request headers: %@", [request allHTTPHeaderFields]);
    NSLog(@"requet body: %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] );
   */ 
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [[NSMutableData alloc] init];
    }
    else {
        self.receivedData = nil;
    }
}

-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:NSWindowsCP1251StringEncoding];
  //  NSLog(@"response for rate: %@", string);
    if (string) {
        NSError *err;
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&err];
        self.callBackBlock(returnDict, nil);
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during getting list of games: %@", [error localizedDescription]);
    self.callBackBlock(nil, error);
}

@end
