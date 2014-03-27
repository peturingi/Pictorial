#import "BBAShowScheduleViewController.h"
#import "BBAColor.h"
#import "BBAShowScheduleCollectionViewController.h"
#import "BBASelectPictogramViewController.h"
#import "Pictogram.h"
#import "../../Database/Repository.h"

@interface BBAShowScheduleViewController ()
@property (strong, nonatomic) BBAShowScheduleCollectionViewController *showScheduleCollectionViewController;
@property (strong, nonatomic) BBASelectPictogramViewController *selectPictogramViewController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@end

@implementation BBAShowScheduleViewController

- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:self.schedule.title];
    [self configureScheduleBackgroundColor];
    [self registerForNotifications];
    [self controlAccessToEditButton];
}

- (void)configureScheduleBackgroundColor {
    [[self view] setBackgroundColor:[self.schedule color]];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlAccessToEditButton)
                                                 name:UIAccessibilityGuidedAccessStatusDidChangeNotification
                                               object:nil];
}

- (void)controlAccessToEditButton {
    self.navigationItem.rightBarButtonItem.enabled = !UIAccessibilityIsGuidedAccessEnabled();
}

- (void)BBA_dismissViewController {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSchedule:(Schedule *)schedule {
    if (!schedule || ![schedule isKindOfClass:[Schedule class]]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"A Schedule must be used as an argument." userInfo:nil] raise];
    }
    _schedule = schedule;
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"embedScheduleCollection"]) {
        _showScheduleCollectionViewController = (BBAShowScheduleCollectionViewController *)segue.destinationViewController;
        [_showScheduleCollectionViewController setSchedule:self.schedule];
        id appDelegate = [[UIApplication sharedApplication] delegate];
        id sharedRepository = [appDelegate valueForKey:@"sharedRepository"];
        NSArray *pictogramsInSchedules = [sharedRepository pictogramsForSchedule:self.schedule includingImages:YES];
        [_showScheduleCollectionViewController setDataSource:pictogramsInSchedules];
    }
    if ([[segue identifier] isEqualToString:@"pictogramSelector"]) {
        _selectPictogramViewController = (BBASelectPictogramViewController *)segue.destinationViewController;
        [_selectPictogramViewController setDelegate:self];
    }
}

#pragma mark Delegate

//- (void)BBASelectPictogramViewController:(BBASelectPictogramViewController *)controller didSelectItem:(Pictogram *)item {
//    NSLog(@"Selected pictogram: %@", item.title);
//    
//    if (![[self.schedule pictograms] containsObject:item]) {
//        [item addUsedByObject:self.schedule];
//        Schedule *s = self.schedule;
//        NSLog(@"Responds? %d", [s respondsToSelector:NSSelectorFromString(@"insertObject:inPictogramsAtIndex:")]);
//        [s insertObject:item inPictogramsAtIndex:self.schedule.pictograms.count];
//        NSLog(@"Added");
//    } else {
//        NSLog(@"Not added");
//    }
//}

@end
