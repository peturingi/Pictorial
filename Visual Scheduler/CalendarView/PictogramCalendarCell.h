#import <UIKit/UIKit.h>
#import "CalendarCell.h"

@interface PictogramCalendarCell : CalendarCell

@property IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end