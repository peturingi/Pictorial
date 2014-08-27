#import "Schedule.h"
#import "PictogramContainer.h"

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

@end
