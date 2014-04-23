@class PictogramsCollectionViewController;
@class Pictogram;

@protocol SelectPictogramViewControllerDelegate

@required
- (void)SelectPictogramViewController:(PictogramsCollectionViewController *)controller didSelectItem:(Pictogram *)item;

@end