//
//  Video.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *videoID;
@property (strong, nonatomic) NSString *userID;


-(id) initWithVideoID:(NSString*)videoIDIn userID:(NSString*)userIDIn eventID:(NSString*)eventIDIn andURL:(NSURL*)urlIn;

-(void) setURLWithString:(NSString*)urlStringIn;

@end
