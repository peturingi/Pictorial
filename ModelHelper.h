#import <Foundation/Foundation.h>

@class Schedule;
@class NSManagedObjectID;

@interface ModelHelper : NSObject

+ (void)insertPictogramWithID:(NSManagedObjectID * const)objectID
                   intoSchedule:(Schedule * const)schedule
       inManagedObjectContext:(NSManagedObjectContext * const)managedObjectContext
                  atIndexPath:(NSIndexPath * const)indexPath;


@end
