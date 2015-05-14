//
//  ViewController.h
//  LastNight
//
//  Created by Matthew Zimmerman on 4/21/15.
//  Copyright (c) 2015 Husky Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "VideoRequestCreator.h"
#import "VideoListViewController.h"
#import "EventListViewController.h"

#define kAnimationCompletionBlock @"animationCompletionBlock"

typedef void (^animationCompletionBlock)(void);

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    
    
    bool showCamera;
    bool showFlash;
    UITapGestureRecognizer  *recordGestureRecognizer;
    UILongPressGestureRecognizer *pressHoldGestureRecognizer;
    
    bool isRecording;
    
    NSMutableData *reqData;
    NSURLConnection *videoConnect;
    
    UIImagePickerControllerQualityType highQuality;
    UIImagePickerControllerQualityType lowQuality;
    
    VideoListViewController *videoListController;
    EventListViewController *eventListController;
    
    NSTimer *recordingTimer;
    
    BOOL recordInProgress;
    BOOL recordingAnimationGoing;
    

}

@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet UIButton *qualityButton;
@property (strong, nonatomic) IBOutlet UIButton *flipCameraButton;

@property (strong, nonatomic) IBOutlet UIImageView *recordingIndicator;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) IBOutlet UIImageView *recordCirlce;

-(IBAction)eventPressed:(id)sender;

-(IBAction)toggleFlash:(id)sender;
-(IBAction)toggleQuality:(id)sender;
-(IBAction)toggleFrontBack:(id)sender;

-(void) startVideoRecording;

-(void) stopVideoRecording;

-(void) setupCamera;

-(void) toggleRecording;

-(void) pressStarted;

-(void) timeExceeded;

-(void) startCountdownAnimation;

-(IBAction)myVideoPressed:(id)sender;

-(IBAction)recordPressed:(id)sender;

-(IBAction)recordReleased:(id)sender;

@property bool isFlashOn;
@property bool isFrontCamera;


@end

