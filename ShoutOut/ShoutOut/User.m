//
//  User.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userID, idNumber, videos;

-(id) initWithUserID:(NSString *)userIDIn andIDNumber:(NSString *)idNumIn {
    if (!self) {
        self = [super init];
    }
    
    [self setUserID:userIDIn];
    [self setIdNumber:idNumIn];
    
    return self;
}

-(void) addVideo:(Video *)videoIn {
    [videos addObject:videoIn];
}


@end
