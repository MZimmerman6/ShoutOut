//
//  VideoListViewController.h
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/3/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    
    NSMutableData *videoListData;
    NSURLConnection *videoConnection;
    NSMutableArray *userList;
    
    NSArray *urlList;
    
    
}


@property (strong, nonatomic) IBOutlet UITableView *videoTable;

-(IBAction)backPressed:(id)sender;

@end
