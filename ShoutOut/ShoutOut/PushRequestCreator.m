//
//  PushRequestCreator.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/1/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "PushRequestCreator.h"
#import <UIKit/UIKit.h>
#import "Definitions.h"
#define BoundaryConstant_APNS @"----------shoutOutvUEYXw1yBznHlsGkdTrFkggb56waLfLZEQ5B7n6b"


@implementation PushRequestCreator

-(NSMutableURLRequest*) createURLRequestForAPNS:(NSString*)deviceToken {
    
    NSString *uuid = [[[UIDevice alloc] identifierForVendor] UUIDString];
    NSLog(@"%@",uuid);
    
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] init];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [urlReq setHTTPShouldHandleCookies:NO];
    [urlReq setTimeoutInterval:60];
    [urlReq setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant_APNS];
    [urlReq setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_APNS] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", uuid] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_APNS] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"deviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant_APNS] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlReq setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [urlReq setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/user",ipAddress, portNumber];
    NSURL *url  = [[NSURL alloc] initWithString:urlString];
    [urlReq setURL:url];
    
    return urlReq;

}

@end
