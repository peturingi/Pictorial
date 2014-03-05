#import <UIKit/UIKit.h>
#import "BBASelectPictogramViewControllerDelegate.h"

@interface BBAAddScheduleViewController : UIViewController <BBASelectPictogramViewControllerDelegate> {
    __weak IBOutlet UITextField *schedulesTitle;
    __weak IBOutlet UIImageView *imageView;
}

@end
