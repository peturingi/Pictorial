#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "../../BBAModel/BBAModel/Schedule.h"

@class BBAScheduleTableDataSource;

@interface BBAScheduleOverviewViewController : UITableViewController

- (void)scheduleTableDataSource:(BBAScheduleTableDataSource *)sender scheduleWasSelectedByUser:(Schedule *)selection;

@end
