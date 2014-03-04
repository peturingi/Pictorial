#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Camera.h"

@interface BBASelectPictogramViewController : UICollectionViewController <CameraDelegate, NSFetchedResultsControllerDelegate> {
    Camera *camera;
}

@end
