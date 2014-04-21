#import <UIKit/UIKit.h>
#import "../Database/Pictogram.h"

@interface CalendarCollectionViewController : UICollectionViewController

- (void)sectionAtPoint:(CGPoint)point;
- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteItemAtIndexPath:(NSIndexPath *)touchedItem;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end