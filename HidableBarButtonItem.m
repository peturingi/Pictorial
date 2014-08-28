//
//  HidableBarButtonItem.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 28/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "HidableBarButtonItem.h"

@implementation HidableBarButtonItem

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)setHidden:(BOOL const)hidden {
    _hidden = hidden;
    
    self.enabled = hidden ? YES : NO;
    self.tintColor = hidden ? [UIApplication sharedApplication].keyWindow.tintColor : [UIColor clearColor];
}

@end
