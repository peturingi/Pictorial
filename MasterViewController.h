#import "CameraDelegate.h"
#import "Camera.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PictogramView.h"
#import "ScheduleCollectionViewController.h"


@interface MasterViewController : UIViewController <CameraDelegate> {
    Camera *camera;
    __weak ScheduleCollectionViewController *_topViewController;
    __weak IBOutlet UIView *bottomView;
    
    __weak PictogramView *_pictogramBeingMoved;
    NSManagedObjectID *_idOfPictogramBeingMoved;
}

- (void)selectedPictogramToAdd:(NSManagedObjectID *)pictogramIdentifier atLocation:(CGPoint)location;
- (void)itemSelectionEndedAtLocation:(CGPoint const)location;
- (void)itemMovedTo:(CGPoint)point;

@end
