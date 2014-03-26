#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Schedule.h"
//#import "Pictogram.h"

@interface BBACoreDataStack : NSObject{
    NSManagedObjectContext* _context;
}

+ (id)sharedInstance;

#pragma mark - Pictogram
- (NSFetchedResultsController *)fetchedResultsControllerForPictograminSchedule:(Schedule *)schedule;
- (NSFetchedResultsController *)fetchedResultsControllerForPictogram;
//- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image;

/**** Refactoring - nothing to see here yet! ***/

+(void)installInMemory:(BOOL)yesno;
+(NSManagedObjectContext*)managedObjectContext;
+(void)rollbackContext;
+(BOOL)saveContext:(NSError**)error;
+(NSManagedObject*)createObjectInContexOfClass:(Class)aClass;
+(void)deleteObjectFromContext:(NSManagedObject*)managedObject;
+(NSFetchedResultsController*)fetchedResultsControllerForClass:(Class)aClass;
@end
