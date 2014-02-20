//
//  Pictogram.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 20/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "Pictogram.h"

@implementation Pictogram

- (id)init {
    NSAssert(FALSE, @"Use initWithImage:");
    return nil;
}

- (id)initWithImage:(NSString *)imageNamed {
    NSAssert(imageNamed, @"Image name is nil.");
    NSAssert(imageNamed.length, @"Image name was \"\"");
    
    self = [super init];
    if (self) {
        _image = [UIImage imageNamed:imageNamed];
        NSAssert(_image, @"Should not be nil.");
    }
    
    return self;
}

@end
