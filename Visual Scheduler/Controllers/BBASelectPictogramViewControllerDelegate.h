@class BBASelectPictogramViewController;
@class NSManagedObjectID;

@protocol BBASelectPictogramViewControllerDelegate
@required
- (void)BBASelectPictogramViewController:(BBASelectPictogramViewController *)controller didSelectItem:(NSManagedObjectID *)itemID;
@end
