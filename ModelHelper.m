#import "ModelHelper.h"
#import <CoreData/CoreData.h>
#import "PictogramContainer.h"
#import "Schedule.h"
#import "Pictogram.h"

@implementation ModelHelper

+ (void)insertPictogramWithID:(NSManagedObjectID * const)objectID
                   intoSchedule:(Schedule * const)schedule
       inManagedObjectContext:(NSManagedObjectContext * const)managedObjectContext
                  atIndexPath:(NSIndexPath * const)indexPath
{
    {
        NSAssert(objectID, @"Cannot insert nil.");
        NSAssert(schedule, @"Unknown destination.");
        NSAssert(indexPath, @"Invalid indexPath");
    } // Assert
    PictogramContainer * const pictogramContainer = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer"
                                                                                  inManagedObjectContext:managedObjectContext];
    {
        NSAssert(pictogramContainer, @"Failed to create pictogram container.");
    } // Assert
    
    
    /* The following lines must be in this order, else insertion inserts random items */
    // Set pictogram in container
    pictogramContainer.pictogram = [managedObjectContext objectWithID:objectID];
    // Insert container in schedule
    NSMutableOrderedSet *pictograms = [[NSMutableOrderedSet alloc] initWithOrderedSet:schedule.pictograms];
    [pictograms insertObject:pictogramContainer atIndex:indexPath.item];
    schedule.pictograms = pictograms;
    // Set schedule in container
    pictogramContainer.schedule = schedule;
}

@end
