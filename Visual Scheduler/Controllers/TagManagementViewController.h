//
//  TagManagementViewController.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataController.h"

@interface TagManagementViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, CoreDataController> {
    
/** Used to conditionally allow the deletion of cells.
 *  Only the cell over which the delete swipe gestuer was performed
 *  changes to edit mode and allows deletion.
 */
    NSIndexPath *_cellToDelete;
}

@end
