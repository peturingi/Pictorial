//
//  PictogramContainer.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 04/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PictogramContainer : NSManagedObject

@property (nonatomic, retain) NSManagedObject *pictogram;
@property (nonatomic, retain) NSManagedObject *schedule;

@end
