//
//  EventListViewController.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListViewController.h"

@interface EventListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    
    NSMutableData *eventListData;
    NSURLConnection *eventConnection;
    NSMutableArray *eventList;
    
    NSMutableArray *eventArray;
    
    VideoListViewController *videoListController;
}


@property (strong, nonatomic) IBOutlet UITableView *eventTable;


-(IBAction)backPressed:(id)sender;

@end
