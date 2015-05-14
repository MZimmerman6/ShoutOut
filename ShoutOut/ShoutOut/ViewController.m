//
//  ViewController.m
//  LastNight
//
//  Created by Matthew Zimmerman on 4/21/15.
//  Copyright (c) 2015 Husky Interactive. All rights reserved.
//

#import "ViewController.h"
#import "VideoListRequestCreator.h"
#import "Definitions.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize flashButton, flipCameraButton, qualityButton, recordingIndicator;
@synthesize isFrontCamera, isFlashOn, recordCirlce;

@synthesize imagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    highQuality = UIImagePickerControllerQualityTypeMedium;
    lowQuality = UIImagePickerControllerQualityType640x480;
    isFrontCamera = NO;
    isFlashOn = NO;
    
    recordInProgress = NO;
    recordingAnimationGoing = NO;
    
    showFlash = NO;
    showCamera = NO;
    
    isRecording = NO;
    
    [self setupCamera];
    
    recordGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRecording)];
    
    pressHoldGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressStarted)];
    
    recordGestureRecognizer.numberOfTapsRequired = 2;
    
    //    [self.view addGestureRecognizer:recordGestureRecognizer];
    
    //    [self.view addGestureRecognizer:pressHoldGestureRecognizer];
    
    
    reqData = [[NSMutableData alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    recordingIndicator.alpha = 0;
    
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
    isRecording = true;
    
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
    
    
    NSString *uuid = [[[UIDevice alloc] identifierForVendor] UUIDString];
    NSMutableURLRequest *urlreq = [VideoRequestCreator generateRequstWithData:videoData userId:uuid eventId:@"4" andName:[[UIDevice currentDevice] name]];
    
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
    
    NSString *uuid = [[[UIDevice alloc] identifierForVendor] UUIDString];
    NSMutableURLRequest *urlReq = [VideoListRequestCreator requestVideoListWithUserID:uuid];
    [videoListController setURLRequest:urlReq];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         [self.navigationController pushViewController:videoListController animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}

-(void) pressStarted {
    NSLog(@"Pressed and Hold Started");
}


-(IBAction)eventPressed:(id)sender {
    
    if (!eventListController) {
        eventListController = [[EventListViewController alloc] initWithNibName:@"EventListViewController" bundle:nil];
    }
    [UIView animateWithDuration:0.5
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         [self.navigationController pushViewController:eventListController animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
}




-(void) timeExceeded {
    NSLog(@"time exceeded");
    [recordCirlce.layer.mask removeAllAnimations];
    recordCirlce.layer.mask = nil;
    if (isRecording == YES) {
        [self stopVideoRecording];
    }
}


-(IBAction)recordPressed:(id)sender {
    NSLog(@"record pressed");
    
    
    recordingTimer = [NSTimer scheduledTimerWithTimeInterval:recordingTimeLimit
                                                      target:self
                                                    selector:@selector(timeExceeded)
                                                    userInfo:nil
                                                     repeats:NO];
    
    [self startCountdownAnimation];
    [self startVideoRecording];
    
}
-(IBAction)recordReleased:(id)sender {
    
    [recordingTimer invalidate];
    NSLog(@"recoring released");
    [recordCirlce.layer.mask removeAllAnimations];
    recordCirlce.layer.mask = nil;
    if (isRecording == YES) {
        [self stopVideoRecording];
    }
    
}

-(void) startCountdownAnimation {
    
    animationCompletionBlock theBlock;
    
    //Create a shape layer that we will use as a mask for the waretoLogoLarge image view
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    CGFloat maskHeight = recordCirlce.layer.bounds.size.height;
    CGFloat maskWidth = recordCirlce.layer.bounds.size.width;
    
    
    CGPoint centerPoint;
    centerPoint = CGPointMake( maskWidth/2, maskHeight/2);
    
    //Make the radius of our arc large enough to reach into the corners of the image view.
    CGFloat radius = sqrtf(maskWidth * maskWidth + maskHeight * maskHeight)/2;
    //  CGFloat radius = MIN(maskWidth, maskHeight)/2;
    
    //Don't fill the path, but stroke it in black.
    maskLayer.fillColor = [[UIColor clearColor] CGColor];
    maskLayer.strokeColor = [[UIColor blackColor] CGColor];
    
    maskLayer.lineWidth = radius; //Make the line thick enough to completely fill the circle we're drawing
    //  maskLayer.lineWidth = 10; //Make the line thick enough to completely fill the circle we're drawing
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    
    //Move to the starting point of the arc so there is no initial line connecting to the arc
    CGPathMoveToPoint(arcPath, nil, centerPoint.x, centerPoint.y-radius/2);
    
    //Create an arc at 1/2 our circle radius, with a line thickess of the full circle radius
    CGPathAddArc(arcPath,
                 nil,
                 centerPoint.x,
                 centerPoint.y,
                 radius/2,
                 3*M_PI/2,
                 -M_PI/2,
                 YES);
    
    maskLayer.path = arcPath;
    
    //Start with an empty mask path (draw 0% of the arc)
    maskLayer.strokeEnd = 0.0;
    
    
    CFRelease(arcPath);
    
    //Install the mask layer into out image view's layer.
    recordCirlce.layer.mask = maskLayer;
    
    //Set our mask layer's frame to the parent layer's bounds.
    recordCirlce.layer.mask.frame = recordCirlce.layer.bounds;
    
    //Create an animation that increases the stroke length to 1, then reverses it back to zero.
    CABasicAnimation *swipe = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    swipe.duration = recordingTimeLimit;
    swipe.delegate = self;
    [swipe setValue: theBlock forKey: kAnimationCompletionBlock];
    
    swipe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    swipe.fillMode = kCAFillModeForwards;
    swipe.removedOnCompletion = NO;
    swipe.autoreverses = NO;
    
    swipe.toValue = [NSNumber numberWithFloat: 1.0];
    
    recordInProgress = TRUE;
    
    //Set up a completion block that will be called once the animation is completed.
    theBlock = ^void(void)
    {
        
        recordingAnimationGoing = NO;
        NSLog(@"recording complete");
    };
    
    
    [swipe setValue: theBlock forKey: kAnimationCompletionBlock];
    
    recordingAnimationGoing = YES;
    [maskLayer addAnimation: swipe forKey: @"strokeEnd"];
}


@end
