#import <UIKit/UIKit.h>
#import "../Database/Pictogram.h"

@interface CalendarCollectionViewController : UICollectionViewController

- (void)sectionAtPoint:(CGPoint)point;
- (void)addPictogram:(Pictogram *)pictogram atIndexPath:(NSIndexPath *)indexPath;

@end