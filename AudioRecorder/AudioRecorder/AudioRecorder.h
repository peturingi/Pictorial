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

/** Wrapper for AVAudioPlayer, AVAudioRecorder and AVAudioSession.
 */
@interface AudioRecorder : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

/** Default Initializer
 @return nil The audio framework could not be configured.
 */
- (id)initWithDelegate:(id<AudioRecorderDelegate>)delegate;

/** Begins recording audio from the default input device.
 */
- (void)recordAudio;

/** Plays back the recorded audio to the default output device.
 */
- (void)playRecording;

/** Stops the audio player if playing.
 *  Stops the recorder if recording.
 */
- (void)stop;

/** Indicates whether recording can begin.
 @discussion If NO is unexpectetly returned, it could indicate that the devices recording capabilities are limited by security settings or the hardware.
 @return YES Recording can begin.
 @return NO Currently in playback or record mode.
 */
- (BOOL)canRecord;

/** Indicates whether audio playback can begin.
 @discussion If NO is unexpectetly returned, it could indicate that the device can not playback due to hardware settings.
 @return YES Playback can begin.
 @return NO Currently in playback or record mode.
 */
- (BOOL)canPlay;

- (BOOL)isPlaying;
- (BOOL)isRecording;

/** Saves the current recording to the specified location.
 @param location The destination file.
 @param error Error, if any.
 @return YES saved successfully.
 @return NO failed to save. See error for details.
 */
- (BOOL)saveRecordingTo:(NSURL *)destination filesystemError:(NSError *)error;

@property (weak, nonatomic)id<AudioRecorderDelegate> delegate;

@end
