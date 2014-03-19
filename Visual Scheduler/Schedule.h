//
//  Schedule.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 19/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * colour;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *pictograms;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addPictogramsObject:(Pictogram *)value;
- (void)removePictogramsObject:(Pictogram *)value;
- (void)addPictograms:(NSSet *)values;
- (void)removePictograms:(NSSet *)values;

@end
