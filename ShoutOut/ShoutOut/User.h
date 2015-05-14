//
//  User.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"
@interface User : NSObject


@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSMutableArray *videos;
@property (strong, nonatomic) NSString *idNumber;

-(id) initWithUserID:(NSString*)userIDIn andIDNumber:(NSString*)idNumIn;

-(void) addVideo:(Video*)videoIn;

@end
