#import "PictogramSelectorViewController.h"
#import <CoreData/CoreData.h>

@implementation PictogramSelectorViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(insertNewPictogramInCollectionView)
                                                     name:PictogramCreatedNotification
                                                   object:nil];
    }
    NSAssert(self, @"Super failed to init.");
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)insertNewPictogramInCollectionView
{
    NSAssert(self.collectionView, @"CollectionView must be available.");
    [self.collectionView reloadData];
}

@end