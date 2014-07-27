#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>
#import "PictogramSelectorDataSource.h"

@implementation PictogramSelectorViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    NSAssert(self, @"Super failed to init.");
    return self;
}


- (IBAction)pictogramLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan)   [self notifyDelegateOfSelectedItem:sender];
    if (sender.state == UIGestureRecognizerStateEnded)   [self.delegate itemSelectionEnded];
    if (sender.state == UIGestureRecognizerStateChanged) [self.delegate itemMovedTo:[sender locationInView:self.view]];
}

- (void)notifyDelegateOfSelectedItem:(UILongPressGestureRecognizer *)sender {
    NSAssert(sender, @"This method must be invoked by a gesture recognizer.");
    
    NSIndexPath *indexPathOfSelectedItem = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.view]];
    const PictogramSelectorDataSource *dataSource = (PictogramSelectorDataSource *)self.collectionView.dataSource;
    const NSManagedObject *selectedItem = [[dataSource fetchedResultsController] objectAtIndexPath:indexPathOfSelectedItem];
    NSAssert(selectedItem, @"Item not found.");
    
    [self.delegate selectedPictogramToAdd:selectedItem.objectID];
}

@end