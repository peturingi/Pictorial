//
//  AudioRecorder.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioRecorderDelegate.h"

@interface AudioRecorder : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

- (void)recordAudio;
- (void)playbackAudio;
- (void)stop;

- (BOOL)canRecord;
- (BOOL)canPlay;
- (BOOL)isPlaying;
- (BOOL)isRecording;

/** Saves the current recording to the specified location.
 @param location The destination file.
 @param error Error, if any.
 @return YES saved successfully.
 @return NO failed to save. See error for details.
 */
- (BOOL)saveRecordingTo:(NSURL *)location error:(NSError *)error;

@property (weak, nonatomic)id<AudioRecorderDelegate> delegate;

@end
