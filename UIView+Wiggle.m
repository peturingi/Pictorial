//
//  UIView+Wiggle.m
//  WiggleTest
//
//  Created by Brian Pedersen on 12/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "UIView+Wiggle.h"

//const NSString* ROTATION_KEY_PATH = @"transform.rotation";
#define ROTATION_KEY_PATH @"transform.rotation"
#define TRANSLATE_Y_KEY_PATH @"transform.translation.y"

#define WIGGLE_ROTATE_KEY @"wiggleRotate"
#define WIGGLE_Y_TRANSLATE_KEY @"woggleTranslateY"

@implementation UIView (Wiggle)
-(void)startWiggle:(float)rotationAmount duration:(float)rotateDuration yTranslateAmount:(float)yTranslateAmount andDuration:(float)yTranslateDuration{
    
    CAAnimation* rotate = [self repeatedRotationAnimation:rotationAmount andDuration:rotateDuration];
    CAAnimation* yTranslate = [self repeatedTranslationYAnimation:yTranslateAmount
                                                      andDuration:yTranslateDuration];
    
    [[self layer]addAnimation:rotate forKey:WIGGLE_ROTATE_KEY];
    [[self layer]addAnimation:yTranslate forKey:WIGGLE_Y_TRANSLATE_KEY];
}


-(void)stopWiggle{
    [[self layer ]removeAnimationForKey:WIGGLE_ROTATE_KEY];
    [[self layer ]removeAnimationForKey:WIGGLE_Y_TRANSLATE_KEY];
}

- (void)startWiggling {
    CAAnimation* rotate = [self repeatedRotationAnimation:0.03f andDuration:0.12f];
    CAAnimation* translateY = [self repeatedTranslationYAnimation:1.5f andDuration:0.12f];
    [[self layer]addAnimation:rotate forKey:WIGGLE_ROTATE_KEY];
    [[self layer]addAnimation:translateY forKey:WIGGLE_Y_TRANSLATE_KEY];
}


-(CAAnimation*)repeatedRotationAnimation:(float)amount andDuration:(float)duration{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:ROTATION_KEY_PATH];
    NSNumber* rotateForward = [NSNumber numberWithFloat:-amount];
    NSNumber* rotateBackwards = [NSNumber numberWithFloat:amount];
    NSArray* values = [NSArray arrayWithObjects:rotateForward, rotateBackwards, nil];
    [animation setValues:values];
    [animation setDuration:duration];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:HUGE_VALF];
    [animation setAdditive:YES];
    return animation;
}

-(CAAnimation*)repeatedTranslationYAnimation:(float)amount andDuration:(float)duration{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:TRANSLATE_Y_KEY_PATH];
    NSNumber* translateUp = [NSNumber numberWithFloat:amount];
    NSNumber* translateDown = [NSNumber numberWithFloat:-amount];
    NSArray* values = [NSArray arrayWithObjects:translateUp, translateDown, nil];
    [animation setValues:values];
    [animation setDuration:duration];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:HUGE_VALF];
    [animation setAdditive:YES];
    return animation;
}
@end
