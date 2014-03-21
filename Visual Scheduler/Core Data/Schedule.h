//
//  Schedule.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 21/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * colour;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *pictograms;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)insertObject:(Pictogram *)value inPictogramsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPictogramsAtIndex:(NSUInteger)idx;
- (void)insertPictograms:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePictogramsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPictogramsAtIndex:(NSUInteger)idx withObject:(Pictogram *)value;
- (void)replacePictogramsAtIndexes:(NSIndexSet *)indexes withPictograms:(NSArray *)values;
- (void)addPictogramsObject:(Pictogram *)value;
- (void)removePictogramsObject:(Pictogram *)value;
- (void)addPictograms:(NSOrderedSet *)values;
- (void)removePictograms:(NSOrderedSet *)values;
@end
