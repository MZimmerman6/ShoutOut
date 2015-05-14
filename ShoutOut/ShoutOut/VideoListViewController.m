//
//  VideoListViewController.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/3/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "VideoListViewController.h"
#import "UserListRequestCreator.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VideoListViewController

@synthesize videoTable;

-(void) viewDidLoad {
    
    [videoTable setDataSource:self];
    [videoTable setDelegate:self];
    urlList = [[NSMutableArray alloc] init];

    
}

-(void) viewDidAppear:(BOOL)animated {
    [videoTable reloadData];
    [videoTable setNeedsDisplay];
}

-(void) viewWillAppear:(BOOL)animated {

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    urlList = [[NSMutableArray alloc] initWithArray:[prefs arrayForKey:@"video_urls"]];
    
    NSLog(@"%lu",(unsigned long)[urlList count]);
    
//    videoListData =[[NSMutableData alloc] init];
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://52.6.123.241:1337/user"]
//                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                          timeoutInterval:5];
//    videoConnection  = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"Connection Finished");
//    NSError *error;
//    NSArray *temp = [NSJSONSerialization JSONObjectWithData:videoListData options:0 error:&error];
//    NSString *userId;
//    
//    NSLog(@"%lu",(unsigned long)[temp count]);
//    for (int i = 0;i<[temp count];i++) {
//        NSDictionary *dict = [temp objectAtIndex:i];
//        
//         userId = [dict objectForKey:@"userid"];
//        if (userId != nil) {
//            [urlList addObject:userId];
//        }
//    }
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [videoListData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    videoListData = [[NSMutableData alloc] init];
    NSLog(@"Connection Failed");
    NSLog(@"%@",error);
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [urlList count];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"VideoTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.frame = CGRectMake(0, 0, videoTable.frame.size.width, 44);
        cell.textLabel.text = [urlList objectAtIndex:indexPath.row];
        
    }
    
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url = [urlList objectAtIndex:indexPath.row];
    
    
    MPMoviePlayerViewController * controller = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    [controller.moviePlayer prepareToPlay];
    [controller.moviePlayer play];
    
    // and present it
    [self presentMoviePlayerViewControllerAnimated:controller];
    
    
}

-(IBAction) backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
