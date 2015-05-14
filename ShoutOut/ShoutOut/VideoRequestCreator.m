//
//  VideoRequestCreator.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 4/30/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "VideoRequestCreator.h"
#import <UIKit/UIKit.h>
#import "Definitions.h"

#define BoundaryConstant_Video @"----------shoutOutvUEYXwTrFkggb56waLfLZEQ5B7n6b1yBznHlsGkd"

@implementation VideoRequestCreator

-(NSMutableURLRequest*) generateRequstWithData:(NSData*)dataIn userId:(NSString*)userIn eventId:(NSString*)eventIn {
    
    NSString *uuid = [[[UIDevice alloc] identifierForVendor] UUIDString];
    NSLog(@"%@",uuid);
    
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] init];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [urlReq setHTTPShouldHandleCookies:NO];
    [urlReq setTimeoutInterval:60];
    
    [urlReq setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant_Video];
    [urlReq setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", userIn] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eventid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", eventIn] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.mp4",userIn,dateString];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:dataIn];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlReq setHTTPBody:body];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    NSLog(@"%@",postLength);
    
    [urlReq setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/videos/upload",ipAddress, portNumber];
    NSLog(@"%@",urlString);
    NSURL *url  = [[NSURL alloc] initWithString:urlString];
    [urlReq setURL:url];
    
    return urlReq;
    
}

+(NSMutableURLRequest*) generateRequstWithData:(NSData*)dataIn
                                        userId:(NSString*)userIn
                                       eventId:(NSString*)eventIn
                                       andName:(NSString*)nameIn {
    
    if ([nameIn caseInsensitiveCompare:@""]) {
        nameIn = @"temp_name";
    }
    
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] init];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [urlReq setHTTPShouldHandleCookies:NO];
    [urlReq setTimeoutInterval:60];
    
    [urlReq setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant_Video];
    [urlReq setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", userIn] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", nameIn] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eventid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", eventIn] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.mp4",userIn,dateString];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:dataIn];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant_Video] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlReq setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    NSLog(@"%@",postLength);
    
    [urlReq setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/videos/upload",ipAddress, portNumber];
    NSLog(@"%@",urlString);
    NSURL *url  = [[NSURL alloc] initWithString:urlString];
    [urlReq setURL:url];
    
    return urlReq;
    
}


@end
