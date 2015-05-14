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


@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    
    
    bool showCamera;
    bool showFlash;
    UITapGestureRecognizer  *recordGestureRecognizer;
    
    bool isRecording;
    
    NSMutableData *reqData;
    NSURLConnection *videoConnect;
    
    UIImagePickerControllerQualityType highQuality;
    UIImagePickerControllerQualityType lowQuality;
    
    VideoListViewController *videoListController;
    

}

@property (strong, nonatomic) IBOutlet UILabel *lab1;



@property (strong, nonatomic) IBOutlet UIView *cameraOverlayView;

@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet UIButton *qualityButton;
@property (strong, nonatomic) IBOutlet UIButton *flipCameraButton;

@property (strong, nonatomic) IBOutlet UIImageView *recordingIndicator;


@property (strong, nonatomic) IBOutlet UIButton *testButton;

@property (strong, nonatomic) UIImagePickerController *imagePicker;


-(IBAction)toggleFlash:(id)sender;
-(IBAction)toggleQuality:(id)sender;
-(IBAction)toggleFrontBack:(id)sender;

-(void) startVideoRecording;

-(void) stopVideoRecording;

-(void) setupCamera;

-(void) toggleRecording;

-(IBAction)myVideoPressed:(id)sender;

@property bool isFlashOn;
@property bool isFrontCamera;


@end

