#import "TimerViewController.h"
#import "TimerView.h"
#import "Timer.h"
#import "NSString+TimeFormatted.h"
@implementation TimerViewController
-(void)viewDidLoad{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self setupTitleLabel];
    [self setupStartStopButton];
    [self setupTimer];
    [self setupAudioPlayer];
    [self setupTimerView];
}

-(void)viewWillAppear:(BOOL)animated{
    [_timerView setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [_timerView didRotateNewFrame:self.view.frame];
    [_timerView setHidden:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([_startStopButton isEnabled] == NO){
        [_startStopButton setTitle:@"Gangsetja"];
        [_startStopButton setEnabled:YES];
        [_audioPlayer stop];
        [_audioPlayer setCurrentTime:0];
    }
}

-(void)setupAudioPlayer{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"m4a"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    [_audioPlayer setNumberOfLoops:-1];
    
    // Always throws C++ exception (__cxa_throw); it does not need to be handled.
    [_audioPlayer prepareToPlay];
}

-(void)timerDidFinish:(Timer *)timer{
    [_timerView startWiggle];
    [_timerView setIsStarted:NO];
    [_startStopButton setEnabled:NO];
    [_audioPlayer play];
}

-(void)timerDidTick:(Timer *)timer withRemainingSeconds:(NSUInteger)seconds{
    [_timerView updateWithTimeInSeconds:seconds];
}

-(void)setupTimer{
    _timer = [[Timer alloc]initWithDelegate:self];
}

-(void)setupTimerView{
    _timerView = [[TimerView alloc]initWithFrame:self.view.frame]; // TODO try self.view.frame þpetur
    [_timerView setLabelToUpdate:_titleLabel];
    [[self view] addSubview:_timerView];
}

-(void)setupTitleLabel{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_titleLabel setText:[NSString timeFormattedStringFromSeconds:0]];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [_titleLabel setTextColor:[UIColor blueColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [[self navigationItem]setTitleView:_titleLabel];
}

-(void)setupStartStopButton{
    _startStopButton = [[UIBarButtonItem alloc]initWithTitle:@"Gangsetja" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTimer:)];
    [[self navigationItem]setRightBarButtonItem:_startStopButton];
}

-(void)toggleTimer:(id)sender{
    if([_timer isStarted]){
        [_startStopButton setTitle:@"Gangsetja"];
        [_timerView setIsStarted:NO];
        [_timer stop];
    }else{
        [_startStopButton setTitle:@"Stoppa"];
        [_timerView setIsStarted:YES];
        [_timer startForSeconds:[_timerView seconds]];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [_timerView setHidden:YES];

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [_timerView didRotateNewFrame:self.view.frame];
    [_timerView setHidden:NO];
}
@end
