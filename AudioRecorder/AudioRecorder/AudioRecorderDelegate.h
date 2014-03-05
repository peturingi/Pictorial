#import <Foundation/Foundation.h>

@protocol AudioRecorderDelegate <NSObject>
@required

/** Posted when audio recording is not currently supported by the device.
 */
- (void)audioRecorderInputIsNotAvailable;

/** Posted when either the user has rejected the request for use of the microphone,
 *  or in case this application is forbidden from using the microphone.
 */
- (void)audioRecorderPermissionToRecordDeniedByUserOrSecuritySettings;
@optional

/** Posted when another application is currently playing audio.
 *  Depending on the set priority of that application, this application
 *  might or might not be able to claim the audio output.
 */
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
