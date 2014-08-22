//
//  Pictogram.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 04/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "Pictogram.h"
#import "PictogramContainer.h"
#import "Visual Scheduler/AppDelegate.h"


@implementation Pictogram

@dynamic image;
@dynamic title;
@dynamic usedBy;

- (UIImage *)uiImage {
    NSData * const imageData = [self valueForKeyPath:CD_KEY_PICTOGRAM_IMAGE];
    return [UIImage imageWithData:imageData];
}

- (BOOL)inUse {
    return self.usedBy.count != 0;
}

@end
