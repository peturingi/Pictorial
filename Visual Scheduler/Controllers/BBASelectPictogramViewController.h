#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BBASelectPictogramViewControllerDelegate.h"
#import "Camera.h"

@interface BBASelectPictogramViewController : UICollectionViewController <CameraDelegate, NSFetchedResultsControllerDelegate> {
    Camera *camera;
}

@property (weak, nonatomic) id<BBASelectPictogramViewControllerDelegate> delegate;
@property (weak, nonatomic) Pictogram *selectedItem;

@end
