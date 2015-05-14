//
//  Event.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

@interface Event : NSObject


@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *videos;

-(id) initWithEventID:(NSString*)eventIDIn andTitle:(NSString*)titleIn;

-(void) addVideo:(Video*)videoIn;

@end
