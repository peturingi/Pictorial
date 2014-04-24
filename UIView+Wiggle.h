//
//  UIView+Wiggle.h
//  WiggleTest
//
//  Created by Brian Pedersen on 12/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

/*
    Enables a UIView to wiggle, similar to how icons on the iOS homescreen wiggles
    whenever the user attempts to delete or move around icons
*/

#import <UIKit/UIKit.h>

@interface UIView (Wiggle)
-(void)stopWiggle;
-(void)startWiggle:(float)rotationAmount duration:(float)rotateDuration yTranslateAmount:(float)yTranslateAmount andDuration:(float)yTranslateDuration;
@end
