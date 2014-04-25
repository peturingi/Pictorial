#define START_ANGLE (3*M_PI/2.0f)
#define RADIUS_FACTOR 0.75f
#import "TimerView.h"
#import "UIView+Wiggle.h"
#import "UIView+CenterPoint.h"
#import "CALayer+WithSizeAndPosition.h"
#import "NSString+TimeFormatted.h"
#import "MathUtils.h"
#import "WatchDialView.h"

@implementation TimerView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addDialSubview];
        [self setDefaultValues];
    }
    return self;
}

-(void)setLabelToUpdate:(UILabel *)label{
    _timeLeftLabel = label;
}

-(void)addDialSubview{
    _watchDialView = [[WatchDialView alloc]initWithFrame:self.frame];
    [self addSubview:_watchDialView];
}

-(void)setDefaultValues{
    _archAngle = 0;
    _seconds = 0;
    _isWiggling = NO;
    _dialIsLocked = NO;
}

-(void)updateWithTimeInSeconds:(NSUInteger)seconds{
    _seconds = seconds;
    _archAngle = [MathUtils angleFromSeconds:seconds];
    [_timeLeftLabel setText:[NSString timeFormattedStringFromSeconds:seconds]];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    CGFloat radiusY = [self centerPoint].y * 0.74f;
    CGFloat radiusX = [self centerPoint].x * 0.74f;
    CGFloat radius = MIN(radiusX, radiusY);
    CGPoint center = CGPointMake([self centerPoint].x, [self centerPoint].y + 22);
    UIBezierPath* arch = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:START_ANGLE endAngle:START_ANGLE - _archAngle clockwise:NO];
    [arch addLineToPoint:center];
    [[UIColor redColor] setFill];
    [arch stroke];
    [arch fill];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    [super touchesBegan:touches withEvent:event];
    _dialIsLocked = NO;
    if(_isStarted == NO && _dialIsLocked == NO && _isWiggling == NO){
        [self updateAngleSecondsDialAndLabelForTouch:[touches anyObject]];
    }
    if(_isWiggling == YES){
        [self stopWiggle];
        _isWiggling = NO;
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
    [super touchesMoved:touches withEvent:event];
    if(_isStarted == NO && _dialIsLocked == NO && _isWiggling == NO){
        [self updateAngleSecondsDialAndLabelForTouch:[touches anyObject]];
    }
    if(_isWiggling == YES){
        [self stopWiggle];
        _isWiggling = NO;
    }
}

-(void)updateAngleSecondsDialAndLabelForTouch:(UITouch*)touch{
    _archAngle = [MathUtils angleBetweenCenter:[self centerPoint] andPoint:[touch locationInView:self]];
    _seconds = [MathUtils secondsFromAngle:_archAngle];
    _seconds = [MathUtils normalizeSecondsToWholeMinutesForSeconds:_seconds];
    _archAngle = [MathUtils normalizeAngleToMinutesForSeconds:_seconds];
    [_timeLeftLabel setText:[NSString timeFormattedStringFromSeconds:_seconds]];
    [self lockDialIfFull];
    [self setNeedsDisplay];
}

-(void)lockDialIfFull{
    if(_archAngle > 6.2f){
        _dialIsLocked = YES;
    }
}

-(void)startWiggle{
    _isWiggling = YES;
    [self startWiggle:0.02f duration:0.2f yTranslateAmount:0.0f andDuration:0.0f];
}

-(void)didRotateNewFrame:(CGRect)frame{
    self.frame = frame;
    [_watchDialView removeFromSuperview];
    [self addDialSubview];
    [self setNeedsDisplay];
}

-(void)setIsStarted:(BOOL)value{
    _isStarted = value;
}

-(NSUInteger)seconds{
    return _seconds;
}

-(BOOL)isWiggling{
    return _isWiggling;
}

@end
