//
//  TagManagementViewController.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "TagManagementViewController.h"
#import "Tag.h"

#pragma mark - Constants

#define CACHE_NAME  @"Root"
#define CELL_REUSE_IDENTIFIER @"Cell"
#define ALERT_TAG_USER_INPUT    10
#define ALERT_CRITICAL_ERROR    20

// Risk of mixing those two up.
// That is why they are defined here.
#define SORT_BY_KEY @"tag"
#define TAG_ENTITY_NAME @"Tag"

#pragma mark - Private Properties

@interface TagManagementViewController ()
    @property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic) NSFetchedResultsController *fetchedResultsController;

    /** Used to conditionally allow the deletion of cells.
    *  Only the cell over which the delete swipe gestuer was performed
    *  changes to edit mode and allows deletion.
    */
    @property (nonatomic, strong) NSIndexPath *cellToDelete;

@end

#pragma mark - Init / Setup

@implementation TagManagementViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Manual registration of the class we want to use for reuseable cells as we are doing this programatically.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
    
    [self configureNavigationBar];
    [self fetchEntities];
    [self setupGestureRecognizers];
}

/** Configures the apperance of the navigation bar
 */
- (void)configureNavigationBar {
    /* Pre */
    NSAssert(self.navigationController, @"This implementation depends on a navigationController");

    self.title = @"Tags";
    _addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(showInputUIForNewTag:)];
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonWasTouched:)];
    self.navigationItem.rightBarButtonItem = _addButton;
    
    /* Post */
    NSAssert(self.navigationItem.rightBarButtonItem, @"Missing button.");
}

/** Configures CoreData, ensures its ready for use.
 */
- (void)fetchEntities {
    NSError *error;
    // fetchedResultsController is configured by sideeffect of its getter.
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

/** Configures gesture recognizers.
 */
- (void)setupGestureRecognizers {
    /* Pre */
    SEL gestureSelector = NSSelectorFromString(@"handleSwipeGesture:");
    NSAssert([self respondsToSelector:gestureSelector], @"Missing implementation of gesture handling method");
    
    /* Left swipe over tableview cell to trigger delete mode */
    NSAssert(self.tableView, @"Must not be nil!");
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:gestureSelector];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    /* Pre */
    NSAssert(gestureRecognizer, @"Must not be nil!");
    NSAssert(self.tableView, @"Must not be nil!");
    
    CGPoint locationOfGestureInView = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationOfGestureInView];
    
    if (indexPath) {
        
        // Making the tableview editable triggers a chainreaction in its delegate; this class is its delegate.
        [self.tableView setEditing:YES animated:NO];
        // Keep reference to the cell marked for deletion, for use in the chainreaction.
        self.cellToDelete = indexPath;
        
        self.navigationItem.rightBarButtonItem = _cancelButton;
        NSAssert(self.navigationItem.rightBarButtonItem, @"No rightBarButton");
    }
}

/** Handles what should happen when the add button is pressed.
 */
- (void)showInputUIForNewTag:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Tag" message:@"Please enter the new tag:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = ALERT_TAG_USER_INPUT;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeAlphabet;
    [alert textFieldAtIndex:0].placeholder = TAG_ENTITY_NAME;
    [alert show];
}

/** Handles what should happen when the cancel button is pressed.
 */
- (void)cancelButtonWasTouched:(id)sender {
    if (self.cellToDelete) {
        /* Pre */
        NSAssert(self.tableView, @"Must not be nil!");
        NSAssert(self.navigationItem, @"Must not be nil!");
        
        self.cellToDelete = nil;
        [self.tableView setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem = _addButton;
        
        /* Post */
        NSAssert(self.tableView.editing == NO, @"Should not be editable!");
        NSAssert(self.navigationItem.rightBarButtonItem == _addButton, @"Failed to set button!");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case ALERT_TAG_USER_INPUT:
            NSAssert(alertView.numberOfButtons == 2, @"Unexpected numberOfButtons.");
            NSAssert([alertView textFieldAtIndex:0].text, @"Could not find input text.");
            
            // OK button clicked?
            if (buttonIndex == 1) {
                // Input contains a string?
                NSString *input = [alertView textFieldAtIndex:0].text;
                if (input.length > 0) {
                    [self createAndSaveNewTag:input];
                }
            }
            break;
            
        case ALERT_CRITICAL_ERROR:
            abort();
            break;
            
        default:
            NSAssert(false, @"Unrecognized alertView.");
    }
}

#pragma mark - Table view

/** Selectivly mark editable, only a row who just received an edit-gesture.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    /* Pre */
    NSAssert(tableView, @"Must not be nil!");
    NSAssert(indexPath, @"Must not be nil!");
    return YES;
    if ([indexPath isEqual:self.cellToDelete]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /* Pre */
    NSAssert(self.fetchedResultsController, @"Must not be nil!");
    
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /* Pre */
    NSAssert(tableView, @"Must not be nil!");
    NSAssert(self.fetchedResultsController, @"Must not be nil!");
    
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSAssert(sectionInfo, @"Must not be nil!");
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /* Pre */
    NSAssert(tableView, @"Must not be nil!");
    NSAssert(indexPath, @"Must not be nil!");
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    NSAssert(cell, @"Must not be nil!");
    return cell;
}

/** Sets cell textLabel to tag.
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    /* Pre */
    NSAssert(cell, @"Must not be nil!");
    NSAssert(indexPath, @"Must not be nil!");
    
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAssert(tag, @"Must not be nil!");
    cell.textLabel.text = tag.tag;
    
    // Layout
    cell.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    // Possible reuse of excisting cell. Remove previous constraints.
    [cell removeConstraints:cell.constraints];
    // Searchbar hugs the top of its superview
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cell.textLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:15]];
    /* Post */
    NSAssert(cell, @"Must not be nil!");
    NSAssert(cell.textLabel.text.length > 0, @"Invalid textLabel");
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    /* Pre */
    NSAssert(tableView, @"Must not be nil!");
    NSAssert(editingStyle, @"Must not be nil!");
    NSAssert(indexPath, @"Must not be nil!");
    NSAssert(self.fetchedResultsController, @"Must not be nil!");
    NSAssert(self.managedObjectContext, @"Must not be nil!");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSAssert(self.tableView.editing, @"Trying to delete from a table which is not marked as editable.");
        
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSAssert(managedObject, @"Must not be nil!");
        
        [self.managedObjectContext deleteObject:managedObject];
        NSAssert(self.managedObjectContext.hasChanges, @"Failed to delete");
        
        [self saveContext];
        
        self.cellToDelete = nil;
        [self.tableView setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem = _addButton;
    }

    /* Post */
    NSAssert(!self.cellToDelete, @"No cell should be marked for deletion.");
    NSAssert(!self.tableView.editing, @"Tableview should not be editable.");
    NSAssert(!self.managedObjectContext.hasChanges, @"Object context should not contain unsaved changes.");
}

#pragma mark - Core Data

/** Getter - lazy instantiates and configures the fetchedResultsController.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    } else {
        NSAssert([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(managedObjectContext)], @"AppDelegate does not respond to a needed selector");
        self.managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
        NSAssert(self.managedObjectContext, @"must not be nil!");
        
        NSEntityDescription *tag = [NSEntityDescription entityForName:TAG_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
        NSAssert(tag, @"must not be nil!");
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:tag];
        [fetchRequest setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_BY_KEY ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:CACHE_NAME];
        _fetchedResultsController.delegate = self;
        
        /* Post */
        NSAssert(_fetchedResultsController, @"must not be nil!");
        NSAssert(_fetchedResultsController.delegate, @"Delegate has not been set.");
        return _fetchedResultsController;
    }
}

/** Commits changes in the context.
 @pre   Context has unsaved changes.
 @post  Context does not have unsaved changes.
 @warning Do not invoke without changes.
 */
- (void)saveContext {
    NSAssert(self.managedObjectContext.hasChanges, @"Nothing to save!");
    
    NSError *saveError;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&saveError]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Critical error."
                                                            message:saveError.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"Abort"
                                                  otherButtonTitles:nil];
            alert.tag = ALERT_CRITICAL_ERROR;
            [alert show];
        }
    }
    NSAssert(!self.managedObjectContext.hasChanges, @"Failed to save all changes!");
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (void)createAndSaveNewTag:(NSString *)title {
    NSAssert(title.length > 0, @"Tag must always contain characters!");
    
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:TAG_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    tag.tag = title;
    [self saveContext];
}

@end
