#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BBAScheduleOverviewViewController.h"
#import "Repository.h"

extern NSString * const kBBACellIdentifier;
extern NSString * const kBBANotificationNameForDidSelectItem;
extern NSString * const kBBANotificationNameForNewDataAvailable;

@interface BBAScheduleTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    __weak Repository *_repository;
}

@property (strong, nonatomic) NSArray *dataSource;

@end