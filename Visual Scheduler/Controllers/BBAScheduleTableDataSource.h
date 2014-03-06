#import <UIKit/UIKit.h>
#import "../../BBAModel/BBAModel/BBAModelStack.h"
#import "BBAScheduleOverviewViewController.h"

@interface BBAScheduleTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    IBOutlet BBAScheduleOverviewViewController *tableViewController;
    IBOutlet UITableView *tableViewControllersTableView;
}
@property (strong, nonatomic) NSFetchedResultsController *dataSource;

@end
