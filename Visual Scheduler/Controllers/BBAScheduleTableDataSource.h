#import <UIKit/UIKit.h>
#import "../../BBAModel/BBAModel/BBAModelStack.h"
#import "BBAScheduleOverviewViewController.h"

@interface BBAScheduleTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) BBAScheduleOverviewViewController *delegate;
@property (strong, nonatomic) NSFetchedResultsController *dataSource;

@end
