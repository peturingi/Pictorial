//
//  Schedule.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 03/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * colour;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *activity;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)insertObject:(Activity *)value inActivityAtIndex:(NSUInteger)idx;
- (void)removeObjectFromActivityAtIndex:(NSUInteger)idx;
- (void)insertActivity:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeActivityAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInActivityAtIndex:(NSUInteger)idx withObject:(Activity *)value;
- (void)replaceActivityAtIndexes:(NSIndexSet *)indexes withActivity:(NSArray *)values;
- (void)addActivityObject:(Activity *)value;
- (void)removeActivityObject:(Activity *)value;
- (void)addActivity:(NSOrderedSet *)values;
- (void)removeActivity:(NSOrderedSet *)values;
@end
