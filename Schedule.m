#import "Schedule.h"
#import "PictogramContainer.h"
#import "AppDelegate.h"

@implementation Schedule

@dynamic color;
@dynamic date;
@dynamic title;
@dynamic pictograms;

- (void)removePictogramAtIndexPath:(NSIndexPath * const)indexPath {
    PictogramContainer *pictogramContainer = [self.pictograms objectAtIndex:indexPath.item];
    {
        NSAssert(pictogramContainer, @"Failed to get container.");
    } // Assert
    [self.managedObjectContext deleteObject:pictogramContainer];
}

- (void)insertPictogramWithID:(NSManagedObjectID * const)objectID
                  atIndexPath:(NSIndexPath * const)indexPath
{
    {
        NSAssert(objectID, @"Cannot insert nil.");
        NSAssert(indexPath, @"Invalid indexPath");
    } // Assert
    PictogramContainer * const pictogramContainer = [NSEntityDescription insertNewObjectForEntityForName:@"PictogramContainer"
                                                                                  inManagedObjectContext:self.managedObjectContext];
    {
        NSAssert(pictogramContainer, @"Failed to create pictogram container.");
    } // Assert
    
    
    /* The following lines must be in this order, else insertion inserts random items */
    // Set pictogram in container
    pictogramContainer.pictogram = [self.managedObjectContext objectWithID:objectID];
    // Insert container in schedule
    NSMutableOrderedSet *pictograms = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.pictograms];
    [pictograms insertObject:pictogramContainer atIndex:indexPath.item];
    self.pictograms = pictograms;
    // Set schedule in container
    pictogramContainer.schedule = self;
}

- (void)setBackgroundColor:(UIColor * const)backgroundColor {
    NSAssert(backgroundColor, @"Expected a background color.");
    self.color = [NSKeyedArchiver archivedDataWithRootObject:backgroundColor];
}

- (UIColor *)backgroundColor {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.color];
}

- (NSString *)description {
    return self.title;
}

+ (NSOrderedSet *)schedules {

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext * const managedObjectContext = appDelegate.managedObjectContext;
    NSAssert(managedObjectContext, @"Failed to get managedObjectContext.");
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY_SCHEDULE];
    
    NSSortDescriptor * const sort = [[NSSortDescriptor alloc] initWithKey:CD_KEY_SCHEDULE_DATE ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:CD_FETCH_BATCH_SIZE];
    NSFetchedResultsController * const fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:CD_KEY_SCHEDULE_DATE
                                                                                   cacheName:nil];
    [fetchedResultsController performFetch:nil]; // TODO: deal with errors
    return [NSOrderedSet orderedSetWithArray:fetchedResultsController.fetchedObjects];
    
}

@end
