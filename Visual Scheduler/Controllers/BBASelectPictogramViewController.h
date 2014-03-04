#import <UIKit/UIKit.h>
#import "Camera.h"

@interface BBASelectPictogramViewController : UICollectionViewController <CameraDelegate> {
    Camera *camera;
}

@end
