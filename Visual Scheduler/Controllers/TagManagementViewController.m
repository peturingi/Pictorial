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
    @property (nonatomic, strong) NSIndexPath *cellMarkedForDeletionByUser;

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
    
    [self configureUserInterface];
    [self fetchEntitiesFromCoreData];
}

- (void)configureUserInterface {
    self.title = @"Tags";
    [self configureTableView];
    [self configureNavigationBar];
}

- (void)configureTableView {
    NSAssert(self.tableView, nil);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
    [self addLeftSwipeGestureRecognizerToTableView];
}

- (void)configureNavigationBar {
    NSAssert(self.navigationItem, nil);
    [self createNavigationButtons];
    [self.navigationItem setRightBarButtonItem:_addButton];
    NSAssert(self.navigationItem.rightBarButtonItem, @"Missing button.");
}

- (void)createNavigationButtons {
    _addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(showInputUIForNewTag:)];
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(abortCellDeletion:)];
}

- (void)fetchEntitiesFromCoreData {
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)addLeftSwipeGestureRecognizerToTableView {
    SEL gestureSelector = NSSelectorFromString(@"handleSwipeGesture:");
    NSAssert([self respondsToSelector:gestureSelector], @"Missing implementation of gesture handling method");
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:gestureSelector];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    NSAssert(self.tableView, nil);
    [self.tableView addGestureRecognizer:swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSAssert(gestureRecognizer, nil);
    NSAssert(self.tableView, nil);
    
    CGPoint locationOfGesture = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationOfGesture];
    
    if (indexPath) {
        [self switchUserInterfaceToEditMode];
        self.cellMarkedForDeletionByUser = indexPath;
    }
}

- (void)switchUserInterfaceToEditMode {
    [self.tableView setEditing:YES animated:NO];
    self.navigationItem.rightBarButtonItem = _cancelButton;
    NSAssert(self.navigationItem.rightBarButtonItem && self.navigationItem.rightBarButtonItem == _cancelButton, nil);
}

- (void)showInputUIForNewTag:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Tag" message:@"Please enter the new tag:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = ALERT_TAG_USER_INPUT;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeAlphabet;
    [alert textFieldAtIndex:0].placeholder = TAG_ENTITY_NAME;
    [alert show];
}

- (void)abortCellDeletion:(id)sender {
    if (self.cellMarkedForDeletionByUser) {
        self.cellMarkedForDeletionByUser = nil;
        [self switchUserInterfaceFromEditModeToNormalMode];
    }
}

- (void)switchUserInterfaceFromEditModeToNormalMode {
    [self.tableView setEditing:NO animated:NO];
    self.navigationItem.rightBarButtonItem = _addButton;
    
    NSAssert(self.tableView && self.tableView.editing == NO, nil);
    NSAssert(self.navigationItem.rightBarButtonItem == _addButton, nil);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case ALERT_TAG_USER_INPUT:
            if (buttonIndex == 1) {
                [self handleUserInputForNewTagFrom:alertView];
            }
            break;
            
        case ALERT_CRITICAL_ERROR:
            abort();
            break;
            
        default:
            NSAssert(false, @"Unrecognized alertView.");
    }
}

- (void)handleUserInputForNewTagFrom:(UIAlertView *)alertView {
    NSAssert(alertView.numberOfButtons == 2, @"Expected OK and Cancel buttons.");
    NSAssert([alertView textFieldAtIndex:0].text, nil);
    
    NSString *input = [alertView textFieldAtIndex:0].text;
    if (input.length > 0) {
        [self createAndSaveNewTag:input];
    }
}

#pragma mark - Table view

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(tableView, nil);
    NSAssert(indexPath, nil);
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSAssert(_fetchedResultsController, nil);
    
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(tableView, nil);
    NSAssert(_fetchedResultsController, nil);
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSAssert(sectionInfo, nil);
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(tableView, nil);
    NSAssert(indexPath, nil);
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    [self prepareCellForReuse:cell];
    [self configureCell:cell atIndexPath:indexPath];
    
    NSAssert(cell, nil);
    return cell;
}

- (void)prepareCellForReuse:(UITableViewCell *)cell {
    NSAssert(cell, nil);
    cell.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell removeConstraints:cell.constraints];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(cell, nil);
    NSAssert(indexPath, nil);
        cell.textLabel.text = [self tagAtIndexPath:indexPath];

    // Searchbar hugs the top of its superview
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cell.textLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cell
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:15]];
    NSAssert(cell, nil);
    NSAssert(cell.textLabel.text.length > 0, @"Invalid textLabel");
}

- (NSString *)tagAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath, nil);
    
    NSAssert(_fetchedResultsController, nil);
    NSString *tagValue = ((Tag *)[self.fetchedResultsController objectAtIndexPath:indexPath]).tag;
    
    NSAssert(tagValue > 0, @"Invalid tag length.");
    return tagValue;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(tableView, nil);
    NSAssert(editingStyle, nil);
    NSAssert(indexPath, nil);
    NSAssert(_fetchedResultsController, nil);
    NSAssert(_managedObjectContext, nil);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteTagForRowAtIndexPath:indexPath];
        [self switchUserInterfaceFromEditModeToNormalMode];
    }

    NSAssert(!self.cellMarkedForDeletionByUser, @"No cell should be marked for deletion.");
    NSAssert(!self.tableView.editing, @"Tableview should not be editable.");
    NSAssert(!self.managedObjectContext.hasChanges, @"Object context should not contain unsaved changes.");
}

- (void)deleteTagForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.tableView.editing, @"Trying to delete from a table which is not marked as editable.");
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAssert(managedObject, nil);
    
    [self.managedObjectContext deleteObject:managedObject];
    [self saveContext];
    
    self.cellMarkedForDeletionByUser = nil;
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
        NSAssert(self.managedObjectContext, nil);
        
        NSEntityDescription *tag = [NSEntityDescription entityForName:TAG_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
        NSAssert(tag, nil);
        
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
        NSAssert(_fetchedResultsController, nil);
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)createAndSaveNewTag:(NSString *)title {
    NSAssert(title.length > 0, @"Tag must always contain characters!");
    
    Tag *tagEntity = [NSEntityDescription insertNewObjectForEntityForName:TAG_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    tagEntity.tag = title;
    [self saveContext];
}

@end
