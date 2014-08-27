#import "ColorSpectrumViewController.h"
#import "UIView+ColorAtPoint.h"
#import "ColorView.h"

/* to get schedule and set colors */
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Schedule.h"

@interface ColorSpectrumViewController ()

@property (weak, nonatomic) IBOutlet ColorView *monday;
@property (weak, nonatomic) IBOutlet ColorView *tuesday;
@property (weak, nonatomic) IBOutlet ColorView *wednesday;
@property (weak, nonatomic) IBOutlet ColorView *thursday;
@property (weak, nonatomic) IBOutlet ColorView *friday;
@property (weak, nonatomic) IBOutlet ColorView *saturday;
@property (weak, nonatomic) IBOutlet ColorView *sunday;

@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;

@property (weak, nonatomic) ColorView *selectedDay;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation ColorSpectrumViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self setupColorViews];
    [self setupLabelViews];
}

- (void)setupColorViews {
    NSOrderedSet *days = [self schedules];
    self.monday.color       = ((Schedule*)days[0]).backgroundColor;
    self.tuesday.color      = ((Schedule*)days[1]).backgroundColor;
    self.wednesday.color    = ((Schedule*)days[2]).backgroundColor;
    self.thursday.color     = ((Schedule*)days[3]).backgroundColor;
    self.friday.color       = ((Schedule*)days[4]).backgroundColor;
    self.saturday.color     = ((Schedule*)days[5]).backgroundColor;
    self.sunday.color       = ((Schedule*)days[6]).backgroundColor;
}

- (void)setupLabelViews {
    NSOrderedSet *days = [self schedules];
    self.mondayLabel.text   = ((Schedule*)days[0]).title;
    self.tuesdayLabel.text  = ((Schedule*)days[1]).title;
    self.wednesdayLabel.text= ((Schedule*)days[2]).title;
    self.thursdayLabel.text = ((Schedule*)days[3]).title;
    self.fridayLabel.text   = ((Schedule*)days[4]).title;
    self.saturdayLabel.text = ((Schedule*)days[5]).title;
    self.sundayLabel.text   = ((Schedule*)days[6]).title;
}

- (IBAction)daySelected:(UITapGestureRecognizer * const)sender {
    self.selectedDay = (ColorView*)sender.view;
}
- (IBAction)colorSelected:(id)sender {
    UIGestureRecognizer *gr = sender;
    if (gr.state == UIGestureRecognizerStateBegan ||
        gr.state == UIGestureRecognizerStateChanged )
    {
        /* Prevent the gesture recognizer from moving out of the view. */
        CGPoint point = [gr locationInView:gr.view];
        CGSize const size = gr.view.bounds.size;
        if (point.x < 0) point.x = 0;
        if (point.y < 0) point.y = 0;
        if (point.x > size.width)  point.x = size.width;
        if (point.y > size.height) point.y = size.height-1; // TODO: Black color if -1 is omitted. I dont know why.
        
        self.selectedDay.color = [gr.view colorAtPoint:point];
    }
}

- (IBAction)save {
    [self applyColors];
    [self.managedObjectContext save:nil]; // TODO: handle errors.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyColors {
    NSOrderedSet *days = [self schedules];
    ((Schedule*)days[0]).backgroundColor = self.monday.color;
    ((Schedule*)days[1]).backgroundColor = self.tuesday.color;
    ((Schedule*)days[2]).backgroundColor = self.wednesday.color;
    ((Schedule*)days[3]).backgroundColor = self.thursday.color;
    ((Schedule*)days[4]).backgroundColor = self.friday.color;
    ((Schedule*)days[5]).backgroundColor = self.saturday.color;
    ((Schedule*)days[6]).backgroundColor = self.sunday.color;
}

- (NSOrderedSet *)schedules {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    NSAssert(self.managedObjectContext, @"Failed to get managedObjectContext.");
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY_SCHEDULE];
    
    NSSortDescriptor * const sort = [[NSSortDescriptor alloc] initWithKey:CD_KEY_SCHEDULE_DATE ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:CD_FETCH_BATCH_SIZE];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:CD_KEY_SCHEDULE_DATE
                                                                               cacheName:nil];
    [self.fetchedResultsController performFetch:nil]; // TODO: deal with errors
    return [NSOrderedSet orderedSetWithArray:self.fetchedResultsController.fetchedObjects];
}

@end
