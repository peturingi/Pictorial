#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Camera.h"
#import "BBASelectPictogramViewControllerDelegate.h"

@interface BBASelectPictogramViewController : UICollectionViewController <CameraDelegate, NSFetchedResultsControllerDelegate> {
    Camera *camera;
}

@property (weak, nonatomic) id<BBASelectPictogramViewControllerDelegate> delegate;

@end
