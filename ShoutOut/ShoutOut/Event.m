//
//  Event.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize videos,title,eventID;


-(id) initWithEventID:(NSString *)eventIDIn andTitle:(NSString *)titleIn {
    if (!self) {
        self = [super init];
    }
    
    [self setEventID:eventIDIn];
    [self setTitle:titleIn];
    videos = [[NSMutableArray alloc] init];
    
    return self;
}

-(void) addVideo:(Video *)videoIn {
    [videos addObject:videoIn];
}


@end
