#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictogramContainer;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSData * color;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *pictograms;

- (void)removePictogramAtIndexPath:(NSIndexPath * const)indexPath;
- (void)insertPictogramWithID:(NSManagedObjectID * const)objectID atIndexPath:(NSIndexPath * const)indexPath;

- (UIColor *)backgroundColor;
- (void)setBackgroundColor:(UIColor * const)backgroundColor;

/* Returns all schedules found in the system. */
+ (NSOrderedSet *)schedules;

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
