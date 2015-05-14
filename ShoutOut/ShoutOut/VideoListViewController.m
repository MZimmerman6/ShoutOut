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
#import "Video.h"

@implementation VideoListViewController

@synthesize videoTable,shortTitle;

-(void) viewDidLoad {
    
    [videoTable setDataSource:self];
    [videoTable setDelegate:self];
    videoList = [[NSMutableArray alloc] init];

    
}

-(void) viewDidAppear:(BOOL)animated {
    [videoTable reloadData];
    [videoTable setNeedsDisplay];
}

-(void) viewWillAppear:(BOOL)animated {

    videoListData =[[NSMutableData alloc] init];
    videoConnection  = [[NSURLConnection alloc] initWithRequest:videoRequest delegate:self startImmediately:YES];
    
}

-(void) setURLRequest:(NSMutableURLRequest *)requestIn {
    videoRequest = requestIn;
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Got Video List");
    NSError *error;
    NSArray *videoArray = [NSJSONSerialization JSONObjectWithData:videoListData options:0 error:&error];
    NSDictionary *videoDict = [videoArray objectAtIndex:0];
    videoArray = [videoDict objectForKey:@"videos"];
    
    Video *tempVid;
    videoList = [[NSMutableArray alloc] init];
    
    for (int j = 0; j < [videoArray count]; j++) {
        tempVid = [[Video alloc] init];
        
        NSDictionary *videoDict = [videoArray objectAtIndex:j];
        
        [tempVid setURLWithString:[videoDict objectForKey:@"url"]];
        [tempVid setEventID:[videoDict objectForKey:@"eventid"]];
        [tempVid setUserID:[videoDict objectForKey:@"userid"]];
        [tempVid setVideoID:[videoDict objectForKey:@"id"]];
        [videoList addObject:tempVid];
    }
    
    [videoTable reloadData];
    
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
    return [videoList count];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *identifier = @"VideoTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        
        Video *temp = [videoList objectAtIndex:indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.frame = CGRectMake(0, 0, videoTable.frame.size.width, 44);
        cell.textLabel.text = temp.videoURL.description;
        
    }
    
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Video *chosenVideo = [videoList objectAtIndex:indexPath.row];
    NSURL *url = [chosenVideo videoURL];
    
    
    MPMoviePlayerViewController * controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [controller.moviePlayer prepareToPlay];
    [controller.moviePlayer play];
    
    [self presentMoviePlayerViewControllerAnimated:controller];
    
    
}

-(IBAction) backPressed:(id)sender {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
