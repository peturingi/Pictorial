@class PictogramsCollectionViewController;
@class NSManagedObjectID;
@class Pictogram;

@protocol BBASelectPictogramViewControllerDelegate
@required
- (void)BBASelectPictogramViewController:(PictogramsCollectionViewController *)controller didSelectItem:(Pictogram *)item;
@end
