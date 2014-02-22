//
//  TagManagementViewController.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "TagManagementViewController.h"
#import "Tag.h"


#define CACHE_NAME  @"Root"
#define CELL_REUSE_IDENTIFIER @"Cell"

@interface TagManagementViewController ()
    @property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

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
    
    NSAssert(self.navigationController, @"This implementation depends on a navigationController");
    NSAssert(self.navigationItem, @"navigationController not found!");
    self.title = @"Tags";
    _addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButton:)];
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.rightBarButtonItem = _addButton;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    // Manual registration of the class we want to use for reuseable cells as we are doing this programatically.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
    
    [self configureGestureRecognizers];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)configureGestureRecognizers {
    SEL gestureSelector = NSSelectorFromString(@"handleGesture:");
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:gestureSelector];
    NSAssert([self respondsToSelector:gestureSelector], @"Missing implementation of gesture handling method");
    
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void)handleGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSAssert(gestureRecognizer, @"must not be nil!");
    
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        _cellToDelete = indexPath;
        [self.tableView setEditing:YES animated:NO];
        self.navigationItem.rightBarButtonItem = _cancelButton;
    }
}

- (void)addButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Tag" message:@"Please enter the new tag:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeAlphabet;
    [alert textFieldAtIndex:0].placeholder = @"Tag";
    [alert show];
}
- (void)cancelButton:(id)sender {
    if (_cellToDelete) {
        _cellToDelete = nil;
        [self.tableView setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem = _addButton;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSAssert(alertView.numberOfButtons == 2, @"Unexpected numberOfButtons.");
    NSAssert([alertView textFieldAtIndex:0].text, @"Could not find input text.");
    
    // OK button clicked?
    if (buttonIndex == 1) {
        // Input contains a string?
        NSString *input = [alertView textFieldAtIndex:0].text;
        if (input.length > 0) {
            [self createNewTag:input];
        }
    }
}


#pragma mark - Table view

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:_cellToDelete]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSAssert(self.fetchedResultsController, @"Must not be nil!");
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.fetchedResultsController, @"Must not be nil!");
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSAssert(sectionInfo, @"Must not be nil!");
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    NSAssert(cell, @"Must not be nil!");
    return cell;
}

/** Sets cell textLabel to tag.
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tag *tag = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSAssert(tag, @"Must not be nil!");
    cell.textLabel.text = tag.tag;
    
    // Layout
    cell.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    // Searchbar hugs the top of its superview
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:cell.textLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:15]];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSAssert(managedObject, @"Must not be nil!");
        [self.managedObjectContext deleteObject:managedObject];
        [self saveContext];
        
        _cellToDelete = nil;
        [self.tableView setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem = _addButton;
    }
    NSAssert(!_cellToDelete, @"No cell should be marked for deletion at this point.");
    NSAssert(!self.tableView.editing, @"It must not be possible to edit the tableView at this point.");
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
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
        NSAssert(entity, @"must not be nil!");
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
        NSFetchedResultsController *newFetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                    managedObjectContext:self.managedObjectContext
                                                                                                      sectionNameKeyPath:nil
                                                                                                               cacheName:CACHE_NAME];
        _fetchedResultsController = newFetchResultsController;
        _fetchedResultsController.delegate = self;
        
        NSAssert(_fetchedResultsController, @"must not be nil!");
        return _fetchedResultsController;
    }
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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

- (void)createNewTag:(NSString *)string {
    NSAssert(string.length > 0, @"Tag must always contain characters!");
    
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    tag.tag = string;
    [self saveContext];
}

@end
