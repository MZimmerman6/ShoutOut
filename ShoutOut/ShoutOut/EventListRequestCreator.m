//
//  EventListRequestCreator.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "EventListRequestCreator.h"
#import "Definitions.h"

@implementation EventListRequestCreator

+(NSMutableURLRequest*) createRequestForEventList {
    
    NSURL *reqURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/events",ipAddress,portNumber]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:reqURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    
    return  request;
}

@end
