#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "BBASelectPictogramViewControllerDelegate.h"

@interface BBAShowScheduleViewController : UIViewController <SelectPictogramViewControllerDelegate>

@property (strong, nonatomic) Schedule *schedule;

@end
