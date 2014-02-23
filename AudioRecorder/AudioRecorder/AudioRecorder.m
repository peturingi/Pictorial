//
//  AudioRecorder.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "AudioRecorder.h"

@interface AudioRecorder ()
    @property (strong, nonatomic) AVAudioRecorder *recorder;
    @property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation AudioRecorder

- (id)initWithDelegate:(id<AudioRecorderDelegate>)delegate {
    NSAssert(delegate, @"A delegate must be passed!");
    if (!delegate) return nil;
    
    self = [super init];
    if (self) {
        _delegate = delegate;
        if (![self configureAudio]) {
            // Abort, audio could not be configured.
            NSAssert(false, @"Failed to configure the audio framework!");
            return nil;
        }
    }
    return self;
}

/** Takes care of configuring the audio framework so it can be used for playback and recording.
 @return YES Successfully configured.
 @return NO Error during configuration.
 */
- (BOOL)configureAudio {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    if (!audioSession.isInputAvailable) {
        [self.delegate audioRecorderInputIsNotAvailable];
    }
    
    if (audioSession.otherAudioPlaying) {
        [self.delegate audioRecorderOtherAudioPlaying];
    }
    
    NSError *audioSessionError;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&audioSessionError];
    if (audioSessionError) {
        NSLog(@"Error getting audiosession: %@", audioSessionError.localizedDescription);
        return NO;
    }
    
    [audioSession setActive:YES error:&audioSessionError];
    if (audioSessionError) {
        NSLog(@"Failed to activate audiosession: %@", audioSessionError.localizedDescription);
        return NO;
    }
    
    NSError *recorderError;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[self temporaryFile] settings:nil error:&recorderError];
    if (recorderError) {
        NSLog(@"Failed to configure AVAudioRecorder: %@", recorderError.localizedDescription);
        return NO;
    }

    return YES;
}

- (void)recordAudio {
    
    
    if ([self canRecord]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self.delegate audioRecorderRecorderAboutToBegin];
                [self.recorder record];
            } else {
                [self.delegate audioRecorderPermissionToRecordDeniedByUserOrSecuritySettings];
            }
        }];
    } else {
        NSString *errorMsg = @"Can not begin recording audio.";
        NSAssert(false, errorMsg);
        NSLog(@"%@",errorMsg);
    }
}

/** Play a previously recorded audiofile.
 */
- (void)playbackAudio {
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&playerError];
    _player.delegate = self;
    if (!self.player || playerError) {
        [NSException raise:NSInternalInconsistencyException format:@"Expected the player to be instantiated"];
    }
    
    if ([self canPlay]) {
        [self.delegate audioRecorderPlayerAboutToBeginPlaying];
        [self.player play];
    } else {
        NSString *errorMsg = @"Can not begin playback.";
        NSAssert(false, errorMsg);
        NSLog(@"%@", errorMsg);
    }
}

/** Stops playback or recording.
 */
- (void)stop {
    
    if (self.recorder && self.recorder.isRecording) {
        [self.recorder stop];
        [self.delegate audioRecorderRecorderDidFinish];
        return;
    }
    
    if (self.player && self.player.isPlaying) {
        [self.player stop];
        self.player.currentTime = 0;
        [self.delegate audioRecorderPlayerDidFinishPlaying];
        return;
    }
    
    NSLog(@"Neither the recorder not the player are active. Nothing to stop!");
}

- (BOOL)canPlay {
    return [self canRecord];
}

- (BOOL)canRecord {
    return !(self.recorder.recording || self.player.playing);
}

- (BOOL)isPlaying {
    return self.player.playing;
}

- (BOOL)isRecording {
    if (!self.recorder) {
        [NSException raise:NSInternalInconsistencyException format:@"Expected the recorder to be instantiated."];
    }
    return self.recorder.recording;
}

/** Finds the devices temporary directory.
 *
 @throws NSInternalInconsistencyException if the directory is not found.
 @return URL of the temporaray directory.
 */
- (NSURL *)temporaryFile {
    NSString *tempDir = NSTemporaryDirectory();
    if (!tempDir) {
        [NSException raise:NSInternalInconsistencyException format:@"NSTemporaryDirectory() returned nil."];
    }
    return [[NSURL alloc] initFileURLWithPath:[tempDir stringByAppendingString:@"temporaryAudioFile"]];
}

- (BOOL)saveRecordingTo:(NSURL *)location error:(NSError *)error{
    NSAssert(self.recorder, @"A recorder is needed as it points to the recording to be saved.");

    [[NSFileManager defaultManager] moveItemAtURL:self.recorder.url toURL:location error:&error];
    
    if (!error) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - Delegate Wrappers
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self.delegate audioRecorderPlayerBeginInterruption];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    [self.delegate audioRecorderPlayerEndInterruption];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self.delegate audioRecorderPlayerDecodingErrorDuringPlayback];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.delegate audioRecorderPlayerDidFinishPlaying];
}

#pragma mark AVAudioRecorderDelegate

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    [self.delegate audioRecorderRecorderBeginInterruption];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self.delegate audioRecorderRecorderDidFinish];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    [self.delegate audioRecorderRecorderEncodeErrorDuringRecording];
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
    [self.delegate audioRecorderRecorderEndInterruption];
}

@end
