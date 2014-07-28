#import "CameraDelegate.h"
#import "Camera.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PictogramView.h"

@interface MasterViewController : UIViewController <CameraDelegate> {
    Camera *camera;
    __weak IBOutlet UIView *bottomView;
    
    __weak PictogramView *_pictogramBeingMoved;
}

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier atLocation:(CGPoint)location;
- (void)itemSelectionEnded;
- (void)itemMovedTo:(CGPoint)point;

@end
