#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "BBASelectPictogramViewControllerDelegate.h"

@interface BBAShowScheduleViewController : UIViewController <BBASelectPictogramViewControllerDelegate>

@property (strong, nonatomic) Schedule *schedule;

@end
