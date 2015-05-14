//
//  EventListViewController.m
//  ShoutOut
//
//  Created by Matthew Zimmerman on 5/14/15.
//  Copyright (c) 2015 Sunny Patel. All rights reserved.
//

#import "EventListViewController.h"
#import "Event.h"
#import "Video.h"
#import "EventListRequestCreator.h"
#import "VideoListRequestCreator.h"

@interface EventListViewController ()

@end

@implementation EventListViewController

@synthesize eventTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [eventTable setDataSource:self];
    [eventTable setDelegate:self];
    eventList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated {
    [eventTable reloadData];
    [eventTable setNeedsDisplay];
    
    eventList = [[NSMutableArray alloc] init];
    
    eventListData = [[NSMutableData alloc] init];
    NSMutableURLRequest *req = [EventListRequestCreator createRequestForEventList];
    eventConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventList count];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"EventTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.frame = CGRectMake(0, 0, eventTable.frame.size.width, 44);
        Event *tempEvent = [eventList objectAtIndex:indexPath.row];
        cell.textLabel.text = [tempEvent title];
        
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *tempEvent = [eventList objectAtIndex:indexPath.row];
    
    videoListController = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
    [videoListController setURLRequest:[VideoListRequestCreator requestVideoListWithEventID:[tempEvent eventID]]];
    [videoListController setShortTitle:[tempEvent title]];
    
    [self.navigationController pushViewController:videoListController animated:YES];
    
    
    NSLog(@"%@",[tempEvent title]);
    
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSLog(@"Got Event List");
    
    NSError *error;
    NSArray *temp = [NSJSONSerialization JSONObjectWithData:eventListData options:0 error:&error];
    Event *holderEvent;
    for (int i = 0; i < [temp count]; i++) {
        
        holderEvent = [[Event alloc] init];
        
        
        NSDictionary *eventDict = [temp objectAtIndex:i];
        NSLog(@"%@",[eventDict objectForKey:@"title"]);
        
        [holderEvent setTitle:[eventDict objectForKey:@"title"]];
        [holderEvent setEventID:[eventDict objectForKey:@"eventid"]];
        
        NSArray *videoArray = [eventDict objectForKey:@"videos"];
        
        Video *tempVid;
        
        for (int j = 0; j < [videoArray count]; j++) {
            tempVid = [[Video alloc] init];
            
            NSDictionary *videoDict = [videoArray objectAtIndex:j];
            
            [tempVid setURLWithString:[videoDict objectForKey:@"url"]];
            [tempVid setEventID:[videoDict objectForKey:@"eventid"]];
            [tempVid setUserID:[videoDict objectForKey:@"userid"]];
            [tempVid setVideoID:[videoDict objectForKey:@"id"]];
            [holderEvent addVideo:tempVid];
        }
        
        [eventList addObject:holderEvent];
    }
    
    [eventTable reloadData];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [eventListData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to get the event list");
    NSLog(@"%@",error.description);
    
}

-(IBAction)backPressed:(id)sender {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
    
}



@end
