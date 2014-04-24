#import <Foundation/Foundation.h>
@class Timer;
@protocol TimerDelegate <NSObject>
@required
-(void)timerDidTick:(Timer*)timer withRemainingSeconds:(NSUInteger)seconds;
-(void)timerDidFinish:(Timer*)timer;
@end

@interface Timer : NSObject{
    NSTimer* _timer;
    NSUInteger _seconds;
    id<TimerDelegate> _delegate;
    BOOL _isStarted;
}

-(BOOL)isStarted;
-(id)initWithDelegate:(id<TimerDelegate>)delegate;
-(void)startForSeconds:(NSUInteger)seconds;
-(void)stop;
@end
