#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Timer.h"
@class TimerView;
@interface TimerViewController : UIViewController <TimerDelegate>{
    TimerView* _timerView;
    UILabel* _titleLabel;
    UIBarButtonItem* _startStopButton;
    Timer* _timer;
    AVAudioPlayer* _audioPlayer;
}
@end
