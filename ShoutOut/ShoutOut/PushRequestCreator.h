//
//  PushRequestCreator.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/1/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushRequestCreator : NSObject


-(NSMutableURLRequest*) createURLRequestForAPNS:(NSString*)deviceToken;

@end
