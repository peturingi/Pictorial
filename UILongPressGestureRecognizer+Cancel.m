//
//  UILongPressGestureRecognizer+Cancel.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 07/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "UILongPressGestureRecognizer+Cancel.h"

@implementation UILongPressGestureRecognizer (Cancel)

- (void)cancel {
    self.enabled = NO;
    self.enabled = YES;
}

@end
