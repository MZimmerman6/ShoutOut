//
//  AppDelegate.m
//  LastNight
//
//  Created by Matthew Zimmerman on 4/21/15.
//  Copyright (c) 2015 Husky Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PushRequestCreator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [navController setNavigationBarHidden:YES];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSMutableString *token = [[NSMutableString alloc] initWithString:[deviceToken description]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<| |>)" options:0 error:nil];
    [regex replaceMatchesInString:token options:0 range:NSMakeRange(0, [token length]) withTemplate:@""];
    
    PushRequestCreator *pushReqCreator = [[PushRequestCreator alloc] init];
    NSMutableURLRequest *urlReq = [pushReqCreator createURLRequestForAPNS:token];
    
    connectData = [[NSMutableData alloc] init];
    apns_connection = [[NSURLConnection alloc] initWithRequest:urlReq delegate:self startImmediately:YES];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [connectData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Uploading UUID and deviceToken to server");
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

@end
