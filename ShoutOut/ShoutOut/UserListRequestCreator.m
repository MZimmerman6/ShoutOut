//
//  UserListRequestCreator.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/3/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "UserListRequestCreator.h"
#import "Definitions.h"

@implementation UserListRequestCreator

+(NSMutableURLRequest*) createURLRequestForUserList {
    
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] init];
    [urlReq setHTTPMethod:@"GET"];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [urlReq setHTTPShouldHandleCookies:NO];
    [urlReq setTimeoutInterval:5];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/user",ipAddress, portNumber];
    NSURL *url  = [[NSURL alloc] initWithString:urlString];
    [urlReq setURL:url];
    
    
    return urlReq;
}

@end
