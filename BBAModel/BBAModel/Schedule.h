#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Pictogram;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * colour;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *activity;
@property (nonatomic, retain) Pictogram *logo;
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