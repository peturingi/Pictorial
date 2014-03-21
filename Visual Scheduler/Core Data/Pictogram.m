//
//  Pictogram.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 19/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "Pictogram.h"
#import "Schedule.h"


@implementation Pictogram

@dynamic imageURL;
@dynamic title;
@dynamic usedBy;

- (NSUInteger)indexInSchedule {
    NSAssert(self.usedBy, @"Cannot get index as this pictogram is not used by any schedule!");
    NSUInteger index = [self.usedBy.pictograms indexOfObject:self];
    return index;
}

@end
