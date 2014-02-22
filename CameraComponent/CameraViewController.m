//
//  CameraViewController.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "CameraViewController.h"
#import "Camera.h"

@interface CameraViewController ()
@property (nonatomic, strong) Camera *camera;
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.camera = [[Camera alloc] initWithViewController:self usingDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CameraComponent";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showCamera:(id)sender {
    
    if (![self.camera show]) {
        NSLog(@"Camera could not be shown!");
    }
}

- (void)cameraDidDisappear {
    NSLog(@"Camera did disappear");
}
- (void)cameraAppeared {
    NSLog(@"Camera appeared");
}
- (void)cameraSnappedPhoto {
    NSLog(@"Camera took a photo!");
    UIImage *img = [self.camera developPhoto];
    [self.view addSubview:[[UIImageView alloc] initWithImage:img]];
}

@end
