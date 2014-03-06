//
//  Activity.h
//  BBAModel
//
//  Created by Brian Pedersen on 04/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictogram, Schedule;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * cancelled;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSOrderedSet *pictogram;
@property (nonatomic, retain) NSSet *schedule;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)insertObject:(Pictogram *)value inPictogramAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPictogramAtIndex:(NSUInteger)idx;
- (void)insertPictogram:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePictogramAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPictogramAtIndex:(NSUInteger)idx withObject:(Pictogram *)value;
- (void)replacePictogramAtIndexes:(NSIndexSet *)indexes withPictogram:(NSArray *)values;
- (void)addPictogramObject:(Pictogram *)value;
- (void)removePictogramObject:(Pictogram *)value;
- (void)addPictogram:(NSOrderedSet *)values;
- (void)removePictogram:(NSOrderedSet *)values;
- (void)addScheduleObject:(Schedule *)value;
- (void)removeScheduleObject:(Schedule *)value;
- (void)addSchedule:(NSSet *)values;
- (void)removeSchedule:(NSSet *)values;

@end
