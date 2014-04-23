#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SelectPictogramViewControllerDelegate.h"
#import "PictogramsCollectionDataSource.h"

@interface PictogramsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

- (Pictogram *)pictogramAtPoint:(CGPoint)point;

/** Returns a frame for the pictograms image.
 @note The frame 'cuts' the text from below the pictograms and its size is only that of the image.
 */
- (CGRect)frameOfPictogramAtPoint:(CGPoint)point;

@end