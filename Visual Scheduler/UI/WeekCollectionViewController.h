#import <UIKit/UIKit.h>

@class Pictogram;

@interface WeekCollectionViewController : UICollectionViewController

- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteItemAtIndexPath:(NSIndexPath *)touchedItem;

@end