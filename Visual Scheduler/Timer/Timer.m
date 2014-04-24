#import "Timer.h"
@implementation Timer
-(id)initWithDelegate:(id<TimerDelegate>)delegate{
    if(self = [super init]){
        _delegate = delegate;
        _isStarted = NO;
    }
    return self;
}

-(void)dealloc{
    [_timer invalidate];
}

-(void)startForSeconds:(NSUInteger)seconds{
    NSAssert(_isStarted == NO, @"Timer was already started");
    _seconds = seconds;
    _isStarted = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)tick{
    if(_seconds == 0){
        [self stop];
        [_delegate timerDidFinish:self];
        return;
    }
    _seconds--;
    [_delegate timerDidTick:self withRemainingSeconds:_seconds];
}

-(BOOL)isStarted{
    return _isStarted;
}

-(void)stop{
    NSAssert(_isStarted == YES, @"Timer was already stopped");
    [_timer invalidate];
    _isStarted = NO;
}
@end
