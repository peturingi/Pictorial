#import <UIKit/UIKit.h>
@interface TimerView : UIView{
    BOOL _dialIsLocked;
    BOOL _isWiggling;
    BOOL _isStarted;
    NSUInteger _seconds;
    UILabel* _timeLeftLabel;
    CGFloat _archAngle;
    UIView* _watchDialView;
}

-(void)didRotateNewFrame:(CGRect)frame;
-(void)setLabelToUpdate:(UILabel*)label;
-(void)updateWithTimeInSeconds:(NSUInteger)seconds;
-(void)setIsStarted:(BOOL)value;
-(void)startWiggle;
-(BOOL)isWiggling;
-(NSUInteger)seconds;
@end
