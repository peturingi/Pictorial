#import "PictogramSelectorViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation PictogramSelectorViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateCollectionView)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:appDelegate.managedObjectContext];
    }
    NSAssert(self, @"Super to init.");
    return self;
}

- (void)updateCollectionView {
    [self.collectionView reloadData];
}

@end
