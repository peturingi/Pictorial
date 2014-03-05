@class BBASelectPictogramViewController;
@class NSManagedObjectID;
@class Pictogram;

@protocol BBASelectPictogramViewControllerDelegate
@required
- (void)BBASelectPictogramViewController:(BBASelectPictogramViewController *)controller didSelectItem:(Pictogram *)item;
@end
