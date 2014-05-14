#import <UIKit/UIKit.h>

@class Pictogram;

@interface WeekCollectionViewController : UICollectionViewController

- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath;
- (void)deletePictogramAtIndexPath:(NSIndexPath *)indexPath;

@end