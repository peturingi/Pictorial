//
//  AudioRecorderDelegate.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioRecorderDelegate <NSObject>
@required
- (void)audioRecorderInputIsNotAvailable;
@optional
- (void)audioRecorderOtherAudioPlaying;

- (void)audioRecorderPlayerAboutToBeginPlaying;
- (void)audioRecorderPlayerDidFinishPlaying;
- (void)audioRecorderPlayerBeginInterruption;
- (void)audioRecorderPlayerEndInterruption;
- (void)audioRecorderPlayerDecodingErrorDuringPlayback;

- (void)audioRecorderRecorderAboutToBegin;
- (void)audioRecorderRecorderDidFinish;
- (void)audioRecorderRecorderBeginInterruption;
- (void)audioRecorderRecorderEndInterruption;
- (void)audioRecorderRecorderEncodeErrorDuringRecording;

@end
