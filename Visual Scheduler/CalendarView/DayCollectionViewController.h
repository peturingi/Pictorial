#import <UIKit/UIKit.h>
#import "../Database/Pictogram.h"

@interface DayCollectionViewController : UICollectionViewController

- (void)sectionAtPoint:(CGPoint)point;
- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteItemAtIndexPath:(NSIndexPath *)touchedItem;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (void)switchToViewMode:(NSInteger)viewMode;

@end