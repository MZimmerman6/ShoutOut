//
//  AppDelegate.h
//  LastNight
//
//  Created by Matthew Zimmerman on 4/21/15.
//  Copyright (c) 2015 Husky Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    
    
    NSURLConnection *apns_connection;
    NSMutableData *connectData;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;


@end

