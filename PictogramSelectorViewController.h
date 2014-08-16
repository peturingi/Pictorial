#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "CellDraggingManager.h"

@interface PictogramSelectorViewController : UICollectionViewController

@property (weak, nonatomic) MasterViewController *delegate;
@property (strong, nonatomic) CellDraggingManager *cellDraggingManager;

@end
