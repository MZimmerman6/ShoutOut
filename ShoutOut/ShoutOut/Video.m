//
//  Video.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "Video.h"

@implementation Video

@synthesize videoID, eventID, userID,videoURL;


-(id) initWithVideoID:(NSString *)videoIDIn
               userID:(NSString *)userIDIn
              eventID:(NSString *)eventIDIn
                title:(NSString*)titleIn
               andURL:(NSURL *)urlIn {
    if (!self) {
        self = [super init];
    }
    
    [self setUserID:userIDIn];
    [self setEventID:eventIDIn];
    [self setVideoID:videoIDIn];
    [self setVideoURL:urlIn];
    [self setVideoTitle:titleIn];
    return self;
}


-(void) setURLWithString:(NSString *)urlStringIn {
    
    NSURL *urlTemp = [NSURL URLWithString:urlStringIn];
    [self setVideoURL:urlTemp];
    
}

@end
