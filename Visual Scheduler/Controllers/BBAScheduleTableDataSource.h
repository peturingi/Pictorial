#import <UIKit/UIKit.h>
#import "../../BBAModel/BBAModel/BBAModelStack.h"
#import "BBAScheduleOverviewViewController.h"

extern NSString * const kBBACellIdentifier;
extern NSString * const kBBANotificationNameForDidSelectItem;
extern NSString * const kBBANotificationNameForNewDataAvailable;

@interface BBAScheduleTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *dataSource;

@end
