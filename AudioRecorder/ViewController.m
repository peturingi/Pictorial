//
//  ViewController.m
//  AudioRecorder
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "ViewController.h"
#import "AudioRecorder.h"

@interface ViewController ()
    @property (strong, nonatomic) AudioRecorder *audioRecorder;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _audioRecorder = [[AudioRecorder alloc] initWithDelegate:self];
    _audioRecorder.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)play:(id)sender {
    [self.audioRecorder playRecording];
}
- (IBAction)stop:(id)sender {
    [self.audioRecorder stop];
}
- (IBAction)record:(id)sender {
    [self.audioRecorder recordAudio];
}

#pragma mark - AudioRecordingDelegate

- (void)audioRecorderRecorderAboutToBegin {
    self.play.enabled = NO;
    self.record.enabled = NO;
    self.stop.enabled = YES;
}

- (void)audioRecorderPlayerAboutToBeginPlaying {
    self.play.enabled = NO;
    self.record.enabled = NO;
    self.stop.enabled = YES;
}

- (void)audioRecorderPlayerDidFinishPlaying {
    self.play.enabled = YES;
    self.record.enabled = YES;
    self.stop.enabled = NO;
}

- (void)audioRecorderRecorderDidFinish {
    self.play.enabled = YES;
    self.record.enabled = YES;
    self.stop.enabled = NO;
}

- (void)audioRecorderInputIsNotAvailable {
    self.play.enabled = NO;
    self.record.enabled = NO;
    self.stop.enabled = NO;
}

- (void)audioRecorderPermissionToRecordDeniedByUserOrSecuritySettings {
    NSLog(@"Permission denied for microphone...");
}



@end
