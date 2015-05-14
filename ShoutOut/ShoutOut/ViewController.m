//
//  ViewController.m
//  LastNight
//
//  Created by Matthew Zimmerman on 4/21/15.
//  Copyright (c) 2015 Husky Interactive. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize flashButton, flipCameraButton, qualityButton, cameraOverlayView, recordingIndicator;
@synthesize isFrontCamera, isFlashOn;

@synthesize imagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    highQuality = UIImagePickerControllerQualityTypeMedium;
    lowQuality = UIImagePickerControllerQualityType640x480;
    isFrontCamera = NO;
    isFlashOn = NO;
    
    showFlash = NO;
    showCamera = NO;
    
    isRecording = NO;
    
    [self setupCamera];
    
    recordGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRecording)];
    recordGestureRecognizer.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:recordGestureRecognizer];
    
    
    reqData = [[NSMutableData alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    recordingIndicator.alpha = 0;
    CGRect theRect = [imagePicker.view frame];
    [cameraOverlayView setFrame:theRect];
    
//    [self.view addSubview:imagePicker.view];
    [self.view insertSubview:imagePicker.view atIndex:0];
    
//    imagePicker.cameraOverlayView = cameraOverlayView;
    
}


-(void) setupCamera {
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    imagePicker.cameraViewTransform = CGAffineTransformIdentity;
    
    
    if ( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear] ) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        if ( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront] ) {
            flipCameraButton.alpha = 1.0;
            showCamera = YES;
        }
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    if ( [UIImagePickerController isFlashAvailableForCameraDevice:imagePicker.cameraDevice] ) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        flashButton.alpha = 1.0;
        showFlash = YES;
    }
    
    imagePicker.videoQuality = lowQuality;
    
    imagePicker.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleFlash:(id)sender {
    
    if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [flashButton setImage:[UIImage imageNamed:@"flash-on.png"] forState:UIControlStateNormal];
    } else {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [flashButton setImage:[UIImage imageNamed:@"flash-off.png"] forState:UIControlStateNormal];
    }
    
}

-(IBAction)toggleQuality:(id)sender {
    
    if (imagePicker.videoQuality == lowQuality) {
        imagePicker.videoQuality = highQuality;
        [qualityButton setImage:[UIImage imageNamed:@"hd-selected.png"] forState:UIControlStateNormal];
    } else {
        imagePicker.videoQuality = lowQuality;
        [qualityButton setImage:[UIImage imageNamed:@"sd-selected.png"] forState:UIControlStateNormal];
    }
    
}

-(IBAction) toggleFrontBack:(id)sender {
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    if ( ![UIImagePickerController isFlashAvailableForCameraDevice:imagePicker.cameraDevice] ) {
        [UIView animateWithDuration:0.3 animations:^(void) {flashButton.alpha = 0;}];
        showFlash = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^(void) {flashButton.alpha = 1.0;}];
        showFlash = YES;
    }
}

-(void) startVideoRecording {
    
    NSLog(@"Starting Video Recording");
    
    void (^hideControls)(void);
    hideControls = ^(void) {
        flipCameraButton.alpha = 0;
        flashButton.alpha = 0;
        qualityButton.alpha = 0;
        recordingIndicator.alpha = 1.0;
    };
    
    void (^recordMovie)(BOOL finished);
    recordMovie = ^(BOOL finished) {
        [imagePicker startVideoCapture];
    };
    
    // Hide controls
    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:hideControls completion:recordMovie];
    
}

-(void) stopVideoRecording {
    [imagePicker stopVideoCapture];
    NSLog(@"Stopping Video Recording");
}

-(void) toggleRecording {
    
    if (isRecording) {
        [self stopVideoRecording];
    } else {
        [self startVideoRecording];
    }
    
    isRecording = !isRecording;
    
    NSLog(@"toggling record");
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    NSString *pathToVideo = [videoURL path];
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSLog(@"%lu", (unsigned long)videoData.length);
    
    VideoRequestCreator *vrc = [[VideoRequestCreator alloc] init];
    
    NSString *uuid = [[[UIDevice alloc] identifierForVendor] UUIDString];
    NSMutableURLRequest *urlreq = [vrc generateRequstWithData:videoData userId:uuid eventId:@"1"];
    
    videoConnect = [[NSURLConnection alloc] initWithRequest:urlreq delegate:self startImmediately:YES];
    
    [self video:pathToVideo didFinishSavingWithError:nil contextInfo:NULL];
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    void (^showControls)(void);
    showControls = ^(void) {
        if (showCamera) flipCameraButton.alpha = 1.0;
        if (showFlash) flashButton.alpha = 1.0;
        qualityButton.alpha = 1.0;
        recordingIndicator.alpha = 0.0;
    };
    
    // Show controls
    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:showControls completion:NULL];
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 
    NSLog(@"got data");
    [reqData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Connection Completed");
    
    NSString *test = [[NSString alloc] initWithData:reqData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",test);
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection failed");
    NSLog(@"%@",[error description]);
}

-(IBAction)myVideoPressed:(id)sender {
    
    NSLog(@"My Video Pressed");
    if (!videoListController) {
        videoListController = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
    }
    [self.navigationController pushViewController:videoListController animated:YES];
}

@end
