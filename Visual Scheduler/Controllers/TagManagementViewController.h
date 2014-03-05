#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataController.h"

@interface TagManagementViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, CoreDataController> {
    
    UIBarButtonItem *_addButton;
    UIBarButtonItem *_cancelButton;
}

@end
