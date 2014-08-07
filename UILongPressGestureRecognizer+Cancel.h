//
//  UILongPressGestureRecognizer+Cancel.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 07/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILongPressGestureRecognizer (Cancel)


/** Causes the gesture recognizer to move into the cancelled state. */
- (void)cancel;

@end
