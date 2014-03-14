//
//  Schedule.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 14/03/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * colour;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *activity;
@property (nonatomic, retain) NSManagedObject *logo;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inActivityAtIndex:(NSUInteger)idx;
- (void)removeObjectFromActivityAtIndex:(NSUInteger)idx;
- (void)insertActivity:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeActivityAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInActivityAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceActivityAtIndexes:(NSIndexSet *)indexes withActivity:(NSArray *)values;
- (void)addActivityObject:(NSManagedObject *)value;
- (void)removeActivityObject:(NSManagedObject *)value;
- (void)addActivity:(NSOrderedSet *)values;
- (void)removeActivity:(NSOrderedSet *)values;
@end
