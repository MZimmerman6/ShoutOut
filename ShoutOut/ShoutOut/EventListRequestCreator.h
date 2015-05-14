//
//  EventListRequestCreator.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventListRequestCreator : NSObject

+(NSMutableURLRequest*) createRequestForEventList;

@end
