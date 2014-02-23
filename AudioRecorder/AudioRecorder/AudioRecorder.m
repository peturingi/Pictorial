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

/** init
 * @throw NSException if an AVAudioSession can not be established.
 */
- (id)init {
    self = [super init];
    if (self) {
        
        [self configureAudio];
        
        // Todo, react to audio notifications.
        // todo, react if user denies audio recording when prompted by the system.
    }
    
    return self;
}

- (void)configureAudio {
    
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
    }
    
    [audioSession setActive:YES error:&audioSessionError];
    if (audioSessionError) {
        NSLog(@"Failed to activate audiosession: %@", audioSessionError.localizedDescription);
    }
    
    NSError *recorderError;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[self temporaryFile] settings:nil error:&recorderError];
    NSAssert(!recorderError, @"Error.");
}

- (void)recordAudio {
    NSAssert([self canRecord], @"Can not begin recording!");
    
    [self.delegate audioRecorderRecorderAboutToBegin];
    [self.recorder record];
}

- (void)playbackAudio {
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&playerError];
    _player.delegate = self;
    NSAssert(!playerError, @"Error.");
    
    NSAssert([self canPlay], @"Can not begin playback!");
    [self.delegate audioRecorderPlayerAboutToBeginPlaying];
    [self.player play];

    NSLog(@"Playing");
}

- (void)stop {
    if (self.recorder.isRecording) {
        [self.recorder stop];
        [self.delegate audioRecorderRecorderDidFinish];
        NSLog(@"Stopped recording");
    }
    if (self.player.isPlaying) {
        [self.player stop];
        self.player.currentTime = 0;
        [self.delegate audioRecorderPlayerDidFinishPlaying];
        NSLog(@"Stopped playing");
    }
}

- (BOOL)canPlay {
    return !(self.player.playing || self.recorder.recording);
}

- (BOOL)canRecord {
    return !(self.recorder.recording || self.player.playing);
}

- (BOOL)isPlaying {
    NSAssert(self.player, @"Must not be nil!");
    return self.player.playing;
}

- (BOOL)isRecording {
    NSAssert(self.recorder, @"Must not be nil!");
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

#pragma mark - AVAudioPlayerDelegate

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

#pragma mark - AVAudioRecorderDelegate

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
