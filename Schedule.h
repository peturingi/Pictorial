//
//  Schedule.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 04/08/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictogramContainer;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSData * color;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *pictograms;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)insertObject:(PictogramContainer *)value inPictogramsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPictogramsAtIndex:(NSUInteger)idx;
- (void)insertPictograms:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePictogramsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPictogramsAtIndex:(NSUInteger)idx withObject:(PictogramContainer *)value;
- (void)replacePictogramsAtIndexes:(NSIndexSet *)indexes withPictograms:(NSArray *)values;
- (void)addPictogramsObject:(PictogramContainer *)value;
- (void)removePictogramsObject:(PictogramContainer *)value;
- (void)addPictograms:(NSOrderedSet *)values;
- (void)removePictograms:(NSOrderedSet *)values;
@end
