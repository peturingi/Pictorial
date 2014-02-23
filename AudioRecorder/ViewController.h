//
//  ViewController.h
//  AudioRecorder
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecorderDelegate.h"

@interface ViewController : UIViewController <AudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *stop;
@property (weak, nonatomic) IBOutlet UIButton *record;

@end
