#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BBASelectPictogramViewControllerDelegate.h"
#import "Camera.h"

@interface BBASelectPictogramViewController : UICollectionViewController <CameraDelegate> {
    Camera *camera;
}

@property (weak, nonatomic) id<BBASelectPictogramViewControllerDelegate> delegate;
@property (weak, nonatomic) Pictogram *selectedItem;

/** Returns the pictograms image at the given point.
 @note The image is from the data source and is as such not of the same size as presented by this controllers collectionview.
 */
- (UIImage *)pictogramAtPoint:(CGPoint)point;

@end