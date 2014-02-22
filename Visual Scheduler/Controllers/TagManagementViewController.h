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
    
    UIBarButtonItem *_addButton;
    UIBarButtonItem *_cancelButton;
}

@end
