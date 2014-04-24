#import "WatchDialView.h"
#import "UIView+CenterPoint.h"
#import "CALayer+WithSizeAndPosition.h"
#import "CALayer+Rotate.h"
#import "MathUtils.h"
#define DIAL_NUMBER_FONT @"HelveticaNeue-Light"
#define DIAL_FONT_SIZE 20
#define NUM_BIG_LINES 4
#define NUM_SMALL_LINES 60

@implementation WatchDialView
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupDialLines];
        [self setupDialNumbers];
    }
    return self;
}

-(void)setupDialNumbers{
    NSArray* dialNumbers = @[@"0", @"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55"];
    CGFloat sliceForEach = TWO_M_PI / [dialNumbers count];
    CGFloat rotationAroundLayer = ((M_PI_2 * [dialNumbers count]));
    for (NSUInteger i = 0; i < [dialNumbers count]; i++) {
        CATextLayer* layer = [self textLayerForDialWithString:[dialNumbers objectAtIndex:i]];
        [self.layer addSublayer:layer];
        CGFloat vertice = [self verticeForTransformForLayer:layer amount:2.3f];
        [layer setAnchorPoint:CGPointMake(0.5f, vertice)];
        if(i == 0){
            continue;
        }
        CGFloat rotationAroundCenterOfDial = sliceForEach * i;
        [layer rotate:-rotationAroundCenterOfDial];
        [self resetAnchorPointForLayer:layer];
        [layer rotate:-rotationAroundLayer];
    }
}

-(CATextLayer*)textLayerForDialWithString:(NSString*)string{
    CATextLayer* layer = [CATextLayer new];
    CGPoint position = CGPointMake([self centerPoint].x,[self centerPoint].y + 30);
    [layer setContentsScale:[[UIScreen mainScreen] scale]];
    [layer setString:string];
    [layer setAlignmentMode:kCAAlignmentCenter];
    [layer setBounds:CGRectMake(0,0,40,40)];
    [layer setPosition:position];
    [layer setForegroundColor:[[UIColor blackColor]CGColor]];
    [layer setFont:CFBridgingRetain([UIFont fontWithName:DIAL_NUMBER_FONT size:DIAL_FONT_SIZE])];
    [layer setFontSize:DIAL_FONT_SIZE];
    return layer;
}

-(void)resetAnchorPointForLayer:(CALayer*)layer{
    CGPoint newPosition = CGPointMake(CGRectGetMidX(layer.frame), CGRectGetMidY(layer.frame));
    [layer setPosition:newPosition];
    [layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
}

-(void)setupDialLines{
    [self renderDialLines:NUM_BIG_LINES withSize:[self sizeForBigDialLine] amountFromCenter:2.6f];
    [self renderDialLines:NUM_SMALL_LINES withSize:[self sizeForSmallDialLine] amountFromCenter:2.7f];
}

-(void)renderDialLines:(NSUInteger)count withSize:(CGRect)size amountFromCenter:(CGFloat)amount{
    CGFloat sliceForEach = TWO_M_PI / count;
    for(NSUInteger i = 0; i < count; i++){
        CGPoint position = CGPointMake([self centerPoint].x, [self centerPoint].y + 22);
        CALayer* layer = [CALayer layerWithSize:size andPosition:position];
        [layer setBackgroundColor:[[UIColor blackColor]CGColor]];
        CGFloat vertice = [self verticeForTransformForLayer:layer amount:amount];
        [layer setAnchorPoint:CGPointMake(0.5f, vertice)];
        [layer rotate:-sliceForEach * i];
        [[self layer] addSublayer:layer];
    }
}

/*
-(CGPoint)adjustedCenterPoint{
    CGPoint point = [self centerPoint];
    point.y -= 22;
    return point;
}
 */

-(CGRect)sizeForSmallDialLine{
    return CGRectMake(0, 0, 2, 20);
}

-(CGRect)sizeForBigDialLine{
    return CGRectMake(0, 0, 4, 40);
}

-(CGFloat)verticeForTransformForLayer:(CALayer*)layer amount:(CGFloat)amount{
//    return [self centerPoint].y / (CGRectGetHeight(layer.bounds) * amount);
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGFloat factor = MIN(height, width);
    return factor / (CGRectGetHeight(layer.bounds) * amount);
    
    //CGFloat height = [self centerPoint].y / (CGRectGetHeight(layer.bounds) * amount);
    //CGFloat width = [self centerPoint].x / (CGRectGetHeight(layer.bounds) * amount);
    //return MIN(height, width);
    //return MIN(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame));
}
@end
