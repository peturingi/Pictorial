#import "CameraDelegate.h"
#import "Camera.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UIViewController <CameraDelegate> {
    Camera *camera;
    __weak IBOutlet UIView *bottomView;
}

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier;
- (void)itemSelectionEnded;
- (void)itemMovedTo:(CGPoint)point;

@end
