//
//  VideoRequestCreator.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 4/30/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoRequestCreator : NSObject


-(NSMutableURLRequest*) generateRequstWithData:(NSData*)dataIn userId:(NSString*)userIn eventId:(NSString*)eventIn;

@end
