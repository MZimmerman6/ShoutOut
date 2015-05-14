//
//  VideoListRequestCreator.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "VideoListRequestCreator.h"
#import "Definitions.h"

@implementation VideoListRequestCreator


+(NSMutableURLRequest*) requestVideoListWithEventID:(NSString*)eventIDIn {
    
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] init];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [urlReq setTimeoutInterval:5];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/events/?eventid=%@",ipAddress,portNumber,eventIDIn];
    [urlReq setURL:[NSURL URLWithString:urlString]];
    
    return urlReq;
}

+(NSMutableURLRequest*) requestVideoListWithUserID:(NSString*)userIDIn {
    
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] init];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [urlReq setTimeoutInterval:5];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/user/?userid=%@",ipAddress,portNumber,userIDIn];
    [urlReq setURL:[NSURL URLWithString:urlString]];
    
    return urlReq;
}

@end
